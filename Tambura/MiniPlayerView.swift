import SwiftUI
import MediaPlayer

struct MiniPlayerView: View {

    @ObservedObject var player = RadioPlayer.shared
    @State private var isVisible = false

    var body: some View {
        Group {
            if player.isPlaying {
                content
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .onAppear {
                        withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
                            isVisible = true
                        }
                    }
            }
        }
        .animation(.spring(response: 0.45, dampingFraction: 0.85), value: player.isPlaying)
    }

    private var content: some View {
        VStack(spacing: 8) { // <-- Wrap everything in a VStack

            HStack(spacing: 14) {
                if let url = URL(string: player.currentStation?.imageURL ?? "") {
                    AsyncImage(url: url) { image in
                        image.resizable()
                    } placeholder: {
                        Color.gray.opacity(0.3)
                    }
                    .frame(width: 40, height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("Now Playing")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text(player.currentTitle)
                        .font(.headline)
                        .lineLimit(1)
                }

                Spacer()

                Button {
                    player.isPlaying ? player.pause() : player.resume()
                } label: {
                    Image(systemName: player.isPlaying ? "pause.fill" : "play.fill")
                        .font(.title3)
                }

                AirPlayButton()
                    .frame(width: 30, height: 30)
            }
            .padding(.horizontal, 16)
            // --- Volume Slider below the controls ---
            VolumeSlider()
                .frame(height: 20)
                .padding(.horizontal, 16)
        }
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(radius: 12)
        .padding(.horizontal)
        .padding(.bottom, 8)
    }

}
