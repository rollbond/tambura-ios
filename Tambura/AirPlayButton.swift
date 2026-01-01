import SwiftUI
import MediaPlayer

struct AirPlayButton: UIViewRepresentable {

    func makeUIView(context: Context) -> MPVolumeView {
        let view = MPVolumeView()
        view.showsVolumeSlider = false
        view.tintColor = .label
        return view
    }

    func updateUIView(_ uiView: MPVolumeView, context: Context) {}
}
