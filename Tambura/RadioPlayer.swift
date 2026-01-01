import AVFoundation
import MediaPlayer
import SwiftUI
import Combine


@MainActor
final class RadioPlayer: ObservableObject {

    static let shared = RadioPlayer()

    @Published var isPlaying = false
    @Published var currentStation: Station?
    @Published var volume: Float = 0.5
    @Published var currentTitle: String = ""

    private let player = AVPlayer()

    private init() {
        setupAudioSession()
        setupRemoteCommands()
    }

    // MARK: - Playback

    func play(station: Station) {
        currentStation = station

        guard let url = URL(string: station.streamURL) else { return }

        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)

        player.play()
        isPlaying = true
        currentTitle = station.name
        setupNowPlaying(station: station)
    }

    func pause() {
        player.pause()
        isPlaying = false
        MPNowPlayingInfoCenter.default().playbackState = .paused
    }

    func resume() {
        player.play()
        isPlaying = true
    }

    func setVolume(_ value: Float) {
        volume = value
        player.volume = value
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

        // Try to get artwork from the station's imageURL
        if let url = URL(string: station.imageURL) {
            Task {
                if let data = try? Data(contentsOf: url),
                   let uiImage = UIImage(data: data) {
                    let artwork = MPMediaItemArtwork(boundsSize: uiImage.size) { _ in uiImage }
                    nowPlaying[MPMediaItemPropertyArtwork] = artwork
                }
                
                MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlaying
                MPNowPlayingInfoCenter.default().playbackState = .playing
            }
        } else {
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlaying
            MPNowPlayingInfoCenter.default().playbackState = .playing
        }
    }

    // MARK: - Remote Commands

    private func setupRemoteCommands() {
        let center = MPRemoteCommandCenter.shared()

        center.playCommand.addTarget { [weak self] _ in
            guard let self, let station = self.currentStation else { return .commandFailed }
            self.play(station: station)
            return .success
        }

        center.pauseCommand.addTarget { [weak self] _ in
            self?.pause()
            return .success
        }
    }
}
