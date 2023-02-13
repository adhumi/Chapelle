import Foundation
import SwiftSoup

struct NordicFranceService {
    func fetchWebpage() async throws -> Document {
        let url = URL(string: "https://www.nordicfrance.fr/nordicfrance_station/chapelle-des-bois/")!
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let html = String(decoding: data, as: UTF8.self)
        
        return try SwiftSoup.parse(html)
    }
}
