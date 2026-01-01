import Foundation

struct StationList: Codable {
    let station: [Station]
}

struct Station: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let streamURL: String
    let imageURL: String
    let desc: String
    let theme: Theme

    enum CodingKeys: String, CodingKey {
        case name, streamURL, imageURL, desc, theme
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = UUID()
        name = try container.decode(String.self, forKey: .name)
        streamURL = try container.decode(String.self, forKey: .streamURL)
        imageURL = try container.decode(String.self, forKey: .imageURL)
        desc = try container.decode(String.self, forKey: .desc)
        theme = try container.decode(Theme.self, forKey: .theme)
    }
}
