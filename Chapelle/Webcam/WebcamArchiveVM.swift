import SwiftUI

@MainActor
class WebcamArchiveVM: ObservableObject {
    var location: WebcamLocation
    @Published var archive: ImageArchiveDay?
    
    init(location: WebcamLocation) {
        self.location = location
    }
    
    func fetchArchive(for date: Date) async {
        do {
            let (data, _) = try await URLSession.shared.data(from: location.dailyArchiveURL(for: date))
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMdd)
            let result = try decoder.decode([ImageArchiveDay].self, from: data)
            archive = result.first
        } catch (let error as NSError) {
            print(error)
            archive = nil
        }
    }
}

struct ImageArchiveDay: Codable {
    let date: Date
    let images: [ImageArchive]
}
