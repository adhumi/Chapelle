import Foundation

struct ImageArchive: Codable, Identifiable {
    let hour: String
    let hourFolder: String
    let imagePath: String
    let image1080Path: String
    let imageHighResPath: String
    
    var id = UUID()
    
    enum CodingKeys: String, CodingKey {
        case hour
        case hourFolder = "hour_folder"
        case imagePath = "src"
        case image1080Path = "src_1080"
        case imageHighResPath = "src_mega"
    }
}

extension ImageArchive {
    var time: Date? {
        let hours = Int(hour.prefix(2))
        let minutes = Int(hour.suffix(2))
        let components = DateComponents(hour: hours, minute: minutes)
        return Calendar.current.date(from: components)
    }
}

extension ImageArchive: Equatable {
    
}

extension DateFormatter {
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    static let urlDateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
}
