import SwiftUI
import AVKit

struct AirPlayButton: UIViewRepresentable {

    func makeUIView(context: Context) -> AVRoutePickerView {
        let button = AVRoutePickerView()
        button.activeTintColor = .blue
        button.backgroundColor = .clear
        button.prioritizesVideoDevices = false // Audio only
        return button
    }

    func updateUIView(_ uiView: AVRoutePickerView, context: Context) {}
}
