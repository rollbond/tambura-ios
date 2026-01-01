import SwiftUI
import MediaPlayer

struct VolumeSlider: View {
    @ObservedObject var player = RadioPlayer.shared

    var body: some View {
        HStack {
            Image(systemName: "speaker.fill")
            Slider(value: Binding(
                get: { player.volume },
                set: { newValue in
                    player.setVolume(newValue)
                }
            ), in: 0...1)
            .accentColor(.blue)
            Image(systemName: "speaker.wave.3.fill")
        }
        .padding(.horizontal)
    }
}
