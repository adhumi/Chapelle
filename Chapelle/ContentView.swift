import SwiftUI
import QuickLook

struct ContentView: View {
    @ObservedObject var vm: ContentVM
    
    @Environment(\.openURL) private var openURL
    
    @State var selectedActivity: Activity = .xcSkiing
    @State var refreshImage = false
    @State var previewUrl: URL? = nil
    
    init() {
        self.vm = ContentVM()
    }
    
    var body: some View {
        NavigationStack {
            List {
                welcomeSection
                
                if let infoMessage = vm.infoMessage, infoMessage != "Secteur fermé" {
                    Section {
                        HStack(alignment: .firstTextBaseline, spacing: 8) { 
                            Label("", systemImage: "info.circle")
                                .labelStyle(.iconOnly)
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(.blue)
                            
                            Text(infoMessage)
                        }
                        .padding(.vertical, 4)
                    }
                    .listRowBackground(Color.blue.opacity(0.1))
                }
                
                webcamSection
                
                if let weather = vm.weather {
                    weatherSection(weather)
                }
                
                tracksSection
                
                miscSection
            }
            .task {
                await vm.loadTracks()
                await vm.loadWeather()
            }
            .refreshable {
                refreshImage.toggle()
                await vm.loadTracks()
                await vm.loadWeather()
            }
        }
#if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
#endif
    }
    
    var tracksFilter: some View {
        Menu {
            ForEach(Activity.allCases) { activity in
                Button {
                    selectedActivity = activity
                } label: {
                    Label(activity.rawValue, systemImage: activity == selectedActivity ? "checkmark" : "")
                }
            }
        } label: {
            HStack {
                Text(selectedActivity.activityTracksLabel)
                Image(systemName: "chevron.down")
                Spacer()
            }
            .font(.title3)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
        }
    }
    
    @ViewBuilder
    var tracksSection: some View {
        
        Section(header: tracksFilter,
                footer: Text("\(vm.tracksFooter())\nSource : [nordicfrance.fr](https://www.nordicfrance.fr/nordicfrance_station/chapelle-des-bois/)")) {
            let tracks = vm.tracks(for: selectedActivity)
            if vm.tracksOpened {
                ForEach(tracks) { track in
                    NavigationLink {
                        TrackView(nordicFranceTrack: track)
                    } label: {
                        TrackCellView(nordicFranceTrack: track)
                    }
                }
            } else {
                HStack {
                    Image(systemName: "xmark.circle")
                        .foregroundColor(.red)
                    Text("Toutes les pistes sont fermées")
                }
                .listRowBackground(Color.red.opacity(0.2))
            }
        }
        .headerProminence(.increased)
    }
    
    var webcamSection: some View {
        Section(footer: Text("Source : [webcam-hd.com](http://m.webcam-hd.com/espace-nordique-jurassien/val-de-mouthe_chapelle-des-bois)")) {
            ZStack {
                NavigationLink(destination: {
                    WebcamsView()
                }) { }
                    .opacity(0)
                
                AsyncImage(url: WebcamLocation.chapelle.liveURL,
                           content: { $0.resizable().scaledToFill().padding(0) },
                           placeholder: { Image("webcam-placeholder").resizable().scaledToFill() })
                    .background(.white)
            }
            .listRowInsets(refreshImage ? .zero : .zero)
        }
        .headerProminence(.increased)
    }
    
    var welcomeSection: some View {
        Section {
            Text(vm.welcomeMessage(withSnowStatus: vm.snowStatus))
                .font(.title2.bold())
                .foregroundColor(.indigo)
                .listRowInsets(.zero)
                .listRowBackground(Color.clear)
        }
    }
    
    func weatherSection(_ weather: Weather) -> some View {
        Section(footer: Text("Source : [yr.no](https://www.yr.no/en/forecast/daily-table/2-6429705)")) {
            WeatherScrollView(weather: weather)
                .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
        }
        .headerProminence(.increased)
    }
    
    var miscSection: some View {
        Section {
            Button {
                previewUrl = Bundle.main.url(forResource: "plan-fond", withExtension: "pdf")
            } label: {
                Label("Plan des pistes de ski de fond", systemImage: "map")
            }
            .quickLookPreview($previewUrl)
            
            Button {
                previewUrl = Bundle.main.url(forResource: "plan-raquettes", withExtension: "pdf")
            } label: {
                Label("Plan des pistes de raquette", systemImage: "map")
            }
            .quickLookPreview($previewUrl)
            
            Button {
                if let url = URL(string: "http://www.chapelledesbois.eu") {
                    openURL(url)
                }
            } label: {
                Label("Photos de la semaine de Gaby Gresset", systemImage: "photo.on.rectangle.angled")
            }
        }
    }
}

extension EdgeInsets {
    static var zero: EdgeInsets {
        return EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
