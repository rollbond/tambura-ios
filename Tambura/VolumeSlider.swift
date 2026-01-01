import SwiftUI

struct VolumeSlider: View {
    @ObservedObject var player = RadioPlayer.shared

    var body: some View {
        HStack {
            Image(systemName: "speaker.fill")
            Slider(value: $player.volume, in: 0...1) {
                Text("Volume")
            }
            .accentColor(.blue)
            Image(systemName: "speaker.wave.3.fill")
        }
        .padding(.horizontal)
    }
}
