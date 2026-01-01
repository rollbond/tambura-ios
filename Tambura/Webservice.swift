import Foundation

enum NetworkError: Error {
    case badURL
    case badResponse
}

final class Webservice {

    private let urlString = "https://yogi-tech.de/app.radioplayer/stations.json"

    func loadStations() async throws -> [Station] {
        guard let url = URL(string: urlString) else {
            throw NetworkError.badURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw NetworkError.badResponse
        }

        return try JSONDecoder().decode(StationList.self, from: data).station
    }
}
