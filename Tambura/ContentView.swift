import SwiftUI

struct ContentView: View {

    @StateObject private var storage = StationStorage()
    @StateObject private var player = RadioPlayer.shared

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                List(storage.stations) { station in
                    Button {
                        storage.selectedStation = station
                        player.play(station: station)
                    } label: {
                        HStack {
                            Text(station.name)
                            Spacer()
                            if player.isPlaying && player.currentStation == station {
                                Image(systemName: "speaker.wave.2.fill")
                            }
                        }
                    }
                }
                .refreshable {
                    await storage.load()
                }

                MiniPlayerView()
            }
            .navigationTitle("Tambura")
            .task {
                await storage.load()
            }
        }
    }
}
