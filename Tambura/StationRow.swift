import SwiftUI

struct StationRow: View {

    let station: Station
    let isSelected: Bool
    let isPlaying: Bool

    var body: some View {
        HStack(spacing: 12) {

            // Station Image
            AsyncImage(url: URL(string: station.imageURL)) { phase in
                switch phase {
                case .empty:
                    Color.gray.opacity(0.3)
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                case .failure:
                    Color.red.opacity(0.3)
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 48, height: 48)
            .background(Color.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 10))

            // Station name
            Text(station.name)
                .font(.headline)

            Spacer()

            // Playing indicator
            if isSelected && isPlaying {
                Image(systemName: "speaker.wave.2.fill")
                    .foregroundColor(.accentColor)
            }
        }
        .contentShape(Rectangle())
    }
}
