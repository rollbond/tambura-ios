import AVFoundation
import Combine
import MediaPlayer
import SwiftUI

@MainActor
final class RadioPlayer: ObservableObject {

    static let shared = RadioPlayer()

    @Published var isPlaying = false

    private let player = AVPlayer()
    private var currentURL: URL?

    private init() {
        setupRemoteCommands()
    }

    func play(station: Station) {
        guard let url = URL(string: station.streamURL) else { return }

        if currentURL != url {
            currentURL = url
            let item = AVPlayerItem(url: url)
            player.replaceCurrentItem(with: item)
        }

        player.play()
        isPlaying = true
        setupNowPlaying(title: station.name)
    }

    func pause() {
        player.pause()
        isPlaying = false
        MPNowPlayingInfoCenter.default().playbackState = .paused
    }

    // MARK: - Now Playing

    private func setupNowPlaying(title: String) {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPMediaItemPropertyTitle: title,
            MPNowPlayingInfoPropertyIsLiveStream: true,
            MPNowPlayingInfoPropertyPlaybackRate: 1.0
        ]
        MPNowPlayingInfoCenter.default().playbackState = .playing
    }

    // MARK: - Remote Commands

    private func setupRemoteCommands() {
        let center = MPRemoteCommandCenter.shared()

        center.playCommand.addTarget { _ in
            self.player.play()
            self.isPlaying = true
            return .success
        }

        center.pauseCommand.addTarget { _ in
            self.pause()
            return .success
        }
    }
}
