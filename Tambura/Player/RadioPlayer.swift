import AVFoundation
import MediaPlayer
import SwiftUI
import Combine

@MainActor
final class RadioPlayer: ObservableObject {

    static let shared = RadioPlayer()

    // MARK: - Published state
    @Published var isPlaying: Bool = false
    @Published var isBuffering: Bool = false
    @Published var currentStation: Station?
    @Published var volume: Float = 0.5
    @Published var currentTitle: String = ""

    // MARK: - Private
    private let player = AVPlayer()
    private var timeControlObserver: NSKeyValueObservation?

    private init() {
        setupAudioSession()
        setupRemoteCommands()   // ✅ already correct place
    }

    // MARK: - Playback

    func play(station: Station) {

        // ⛔️ Prevent rebuffering if this station is already playing
        if currentStation?.id == station.id {
            // Optional: resume if paused
            if !isPlaying {
                resume()
            }
            return
        }

        currentStation = station
        currentTitle = station.name
        isBuffering = true

        guard let url = URL(string: station.streamURL) else { return }

        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)

        observeBuffering(for: item)

        player.play()
        isPlaying = true

        setupNowPlaying(station: station)
    }

    func pause() {
        player.pause()
        isPlaying = false
        isBuffering = false
        MPNowPlayingInfoCenter.default().playbackState = .paused
    }

    func resume() {
        player.play()
        isPlaying = true
        MPNowPlayingInfoCenter.default().playbackState = .playing
    }

    func stop(storage: StationStorage) {
        player.pause()
        player.replaceCurrentItem(with: nil)
        isPlaying = false
        isBuffering = false
        currentStation = nil
        currentTitle = ""

        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
        MPNowPlayingInfoCenter.default().playbackState = .stopped

        storage.selectedStation = nil
    }

    func setVolume(_ value: Float) {
        volume = value
        player.volume = value
    }

    // MARK: - Buffering observer

    private func observeBuffering(for item: AVPlayerItem) {
        timeControlObserver?.invalidate()

        timeControlObserver = player.observe(
            \.timeControlStatus,
            options: [.initial, .new]
        ) { [weak self] player, _ in
            guard let self else { return }

            DispatchQueue.main.async {
                switch player.timeControlStatus {
                case .waitingToPlayAtSpecifiedRate:
                    self.isBuffering = true
                    self.isPlaying = false
                case .playing:
                    self.isBuffering = false
                    self.isPlaying = true
                case .paused:
                    self.isBuffering = false
                    self.isPlaying = false
                @unknown default:
                    self.isBuffering = false
                    self.isPlaying = false
                }
            }
        }
    }

    // MARK: - Audio Session

    private func setupAudioSession() {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playback, mode: .default, options: [.allowAirPlay])
        try? session.setActive(true)
    }

    // MARK: - Now Playing

    private func setupNowPlaying(station: Station) {
        var nowPlaying: [String: Any] = [
            MPMediaItemPropertyTitle: station.name,
            MPNowPlayingInfoPropertyIsLiveStream: true,
            MPNowPlayingInfoPropertyPlaybackRate: 1.0
        ]

        // Fetch station image for artwork
        Task {
            if let url = URL(string: station.imageURL),
               let data = try? Data(contentsOf: url),
               let uiImage = UIImage(data: data) {

                let artwork = MPMediaItemArtwork(boundsSize: uiImage.size) { _ in uiImage }
                nowPlaying[MPMediaItemPropertyArtwork] = artwork
            }

            // Update Now Playing Center
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlaying
            MPNowPlayingInfoCenter.default().playbackState = .playing
        }
    }


    // MARK: - Remote Commands (UPDATED)

    private func setupRemoteCommands() {
        let center = MPRemoteCommandCenter.shared()

        // Play
        center.playCommand.addTarget { [weak self] _ in
            guard let self else { return .commandFailed }
            self.resume()
            return .success
        }

        // Pause
        center.pauseCommand.addTarget { [weak self] _ in
            self?.pause()
            return .success
        }

        // ✅ NEXT STATION
        center.nextTrackCommand.isEnabled = true
        center.nextTrackCommand.addTarget { [weak self] _ in
            self?.playNextStation()
            return .success
        }

        // ✅ PREVIOUS STATION
        center.previousTrackCommand.isEnabled = true
        center.previousTrackCommand.addTarget { [weak self] _ in
            self?.playPreviousStation()
            return .success
        }
    }

    // MARK: - Station Navigation (NEW)

    private func playNextStation() {
        let storage = StationStorage.shared
        guard let next = storage.nextStation(from: storage.selectedStation) else { return }
        storage.selectedStation = next
        play(station: next)
    }

    private func playPreviousStation() {
        let storage = StationStorage.shared
        guard let prev = storage.previousStation(from: storage.selectedStation) else { return }
        storage.selectedStation = prev
        play(station: prev)
    }
}
