import SwiftUI
import MediaPlayer

struct MiniPlayerView: View {

    @ObservedObject var player = RadioPlayer.shared

    var body: some View {
        if let station = player.currentStation {
            VStack(spacing: 12) {

                Divider()

                HStack(spacing: 12) {

                    VStack(alignment: .leading) {
                        Text(station.name)
                            .font(.headline)
                            .lineLimit(1)

                        Text(player.isPlaying ? "Playing" : "Paused")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    Button {
                        player.togglePlayPause()
                    } label: {
                        Image(systemName: player.isPlaying
                              ? "pause.circle.fill"
                              : "play.circle.fill")
                        .font(.system(size: 44))
                    }
                }

                // Volume
                HStack {
                    Image(systemName: "speaker.fill")
                    Slider(value: $player.volume, in: 0...1)
                    Image(systemName: "speaker.wave.3.fill")
                }

                // AirPlay
                HStack {
                    Spacer()
                    AirPlayButton()
                }
            }
            .padding()
            .background(.ultraThinMaterial)
        }
    }
}
