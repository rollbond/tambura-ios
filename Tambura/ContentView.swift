import SwiftUI

struct ContentView: View {

    @StateObject private var storage = StationStorage()
    @StateObject private var player = RadioPlayer.shared

    var body: some View {
        NavigationStack {
            List(storage.stations) { station in
                Button {
                    storage.selectedStation = station
                    player.play(station: station)
                } label: {
                    HStack {
                        Text(station.name)
                        Spacer()
                        if player.isPlaying && storage.selectedStation == station {
                            Image(systemName: "speaker.wave.2.fill")
                        }
                    }
                }
            }
            .navigationTitle("Tambura")
            .task {
                await storage.load()
            }
        }
    }
}
