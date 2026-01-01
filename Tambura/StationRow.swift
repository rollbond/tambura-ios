import SwiftUI

struct StationRow: View {
    let station: Station
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 12) {
            
            // Station Image
            AsyncImage(url: URL(string: station.imageURL)) { phase in
                switch phase {
                case .empty:
                    // Placeholder while loading
                    Color.gray.opacity(0.3)
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                case .success(let image):
                    // Loaded image
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                case .failure(let error):
                    // Failed to load
                    Color.red
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            Image(systemName: "xmark.octagon.fill")
                                .foregroundColor(.white)
                        )
                        .onAppear {
                            print("❌ Failed to load image for station '\(station.name)':", error)
                        }
                @unknown default:
                    // Fallback for future cases
                    Color.gray
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }

            // Station name
            Text(station.name)
                .font(.headline)

            Spacer()

            // Play/Pause indicator if selected
            if isSelected {
                Image(systemName: RadioPlayer.shared.isPlaying ? "play.circle.fill" : "pause.circle.fill")
                    .foregroundColor(.blue)
            }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle()) // Makes whole row tappable
    }
}

struct StationRow_Previews: PreviewProvider {
    static var previews: some View {
        StationRow(
            station: Station(
                name: "Test Station",
                streamURL: "https://example.com/stream",
                imageURL: "https://via.placeholder.com/50",
                desc: "Sample description",
                theme: Theme(firstColor: "#FFFFFF", secondColor: "#000000", thirdColor: "#FF0000")
            ),
            isSelected: true
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
