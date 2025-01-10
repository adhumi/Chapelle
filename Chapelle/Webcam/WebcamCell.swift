import SwiftUI

struct WebcamCell: View {
    let location: WebcamLocation
    @State private var isSharePresented: Bool = false
    @State var showArchives: Bool = false
    @State var selectedImage: ImageArchive?
    @State var selectedDate: Date = Date()
    @ObservedObject var vm: WebcamArchiveVM
    
    init(location: WebcamLocation) {
        self.location = location
        self.vm = WebcamArchiveVM(location: location)
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(location.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            
            VStack {
                webcamView(location: location)
                
                Button {
                    withAnimation {
                        showArchives.toggle()
                    }
                } label: {
                    Label(showArchives ? "Masquer les archives" : "Afficher les archives",
                          systemImage: showArchives ? "chevron.compact.up" : "chevron.compact.down")
                        .font(.footnote)
                }
                
                if showArchives {
                    archivePickerView(location: location)
                }
            }
            .padding(.bottom, 8)
            .background(Color("CellBackground"))
            .cornerRadius(12)
        }
    }
    
    func thumbnail(for location: WebcamLocation) -> URL {
        return selectedImage == nil ? location.liveURL : location.archivedImageURL(for: selectedDate, archive: selectedImage!)
    }
    
    func webcamView(location: WebcamLocation) -> some View {
        ZStack {
            AsyncImage(url: thumbnail(for: location),
                       content: { image in
                image
                    .resizable()
                    .scaledToFill()
            }, placeholder: {
                Image("webcam-placeholder")
                    .resizable()
                    .scaledToFill()
            })
                .background(.regularMaterial)
            
            VStack {
                Spacer()
                
                HStack(alignment: .center) {
#if os(iOS)
                    Button {
                        self.isSharePresented = true
                    } label: {
                        Image(systemName: "square.and.arrow.up.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.white)
                            .font(.system(size: 30))
                    }
                    .sheet(isPresented: $isSharePresented, onDismiss: {
                        print("Dismiss")
                    }, content: {
                        ActivityViewController(activityItems: [location.shareURL])
                    })
#endif
                    
                    Spacer()
                }
                .padding(8)
            }
        }
        .listRowInsets(.zero)
        .frame(maxWidth: .infinity)
    }
    
    func archivePickerView(location: WebcamLocation) -> some View {
        VStack {
            HStack {
                Spacer()
                
                Label("", systemImage: "clock.arrow.circlepath")
                    .font(.body.bold())
                    .labelStyle(.iconOnly)
                
                DatePicker("",
                           selection: $selectedDate,
                           in: ...Date(),
                           displayedComponents: .date)
                    .task {
                        await vm.fetchArchive(for: selectedDate)
                    }
                    .onChange(of: selectedDate) { date in
                        Task {
                            await vm.fetchArchive(for: date)
                        }
                    }
                    .labelsHidden()
                
                Spacer()
            }
            
            if let archive = vm.archive {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(archive.images) { image in
                            if let formattedTime = formattedTime(for: image) {
                                Button {
                                    selectedImage = image
                                } label: {
                                    Text(formattedTime)
                                }
                                .padding(8)
                                .background(.regularMaterial)
                                .cornerRadius(8)
                            }
                        }
                    }
                }
                .padding(.top, 12)
            } else {
                Text("Pas d'archives pour cette date")
            }
        }
        .listRowInsets(.zero)
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    
    func formattedTime(for archive: ImageArchive) -> String? {
        guard let time = archive.time else { return nil }
        return timesFormatter.string(from: time)
    }
    
    let timesFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
}
