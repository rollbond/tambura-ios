import Foundation

struct StationList: Codable {
    let station: [Station]
}

struct Station: Identifiable, Hashable, Codable {
    let id: UUID = UUID()       // locally generated ID
    let name: String
    let streamURL: String
    let imageURL: String
    let desc: String
    let theme: Theme

    enum CodingKeys: String, CodingKey {
        case name, streamURL, imageURL, desc, theme
    }
}

struct Theme: Codable, Hashable {
    let firstColor: String
    let secondColor: String
    let thirdColor: String
}
