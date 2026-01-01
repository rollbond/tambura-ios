import Combine
import Foundation
import SwiftUI

@MainActor
final class StationStorage: ObservableObject {

    @Published var stations: [Station] = []
    @Published var selectedStation: Station?

    private let service = Webservice()

    func load() async {
        do {
            stations = try await service.getStations()
        } catch {
            print("❌ Failed to load stations:", error)
        }
    }
}
