import SwiftUI
import SwiftSoup

struct NordicFranceTrack: Identifiable {
    enum Status: String {
        case opened = "opened"
        case closed = "closed"
        case partiallyOpened = "openedPartial"
        
        var color: Color {
            switch self {
                case .opened:
                    return .green
                case .closed:
                    return .red
                case .partiallyOpened:
                    return .orange
            }
        }
        
        var systemImageName: String {
            switch self {
                case .opened:
                    return "checkmark.circle"
                case .closed:
                    return "xmark.circle"
                case .partiallyOpened:
                    return "exclamationmark.2"
            }
        }
        
        var description: String {
            switch self {
                case .opened:
                    return "Ouverte"
                case .closed:
                    return "Fermée"
                case .partiallyOpened:
                    return "Partiellement ouverte"
            }
        }
    }
    
    enum Difficulty: String {
        case green = "Vert"
        case blue = "Bleu"
        case red = "Rouge"
        case black = "Noir"
        
        var color: Color {
            switch self {
                case .green:
                return .green
                case .blue:
                return .blue
                case .red:
                return .red
                case .black:
                return .black
            }
        }
        
        var description: String {
            switch self {
                case .green:
                return "Verte"
                case .blue:
                return "Bleue"
                case .red:
                return "Rouge"
                case .black:
                return "Noire"
            }
        }
        
        var sort: Int {
            switch self {
                case .green:
                    return 0
                case .blue:
                    return 1
                case .red:
                    return 2
                case .black:
                    return 3
            }
        }
    }
    
    let activity: Activity?
    let name: String
    let info: String?
    let difficulty: Difficulty?
    let status: Status?
    let id: String
    
    private let _length: Int?
    var length: Int? {
        return metadata?.length ?? _length
    }
    
    let metadata: TrackMetadata?
    
    init(activity: Activity?, name: String, info: String?, difficulty: Difficulty?, status: Status?, length: Int?) {
        self.activity = activity
        self.name = name
        self.info = info
        self.difficulty = difficulty
        self.status = status
        self.id = name
        self._length = length
        self.metadata = TrackMetadata(name: name)
    }
    
    init(element: Element) throws {
        let activityElement = try element.select("div.NordicDetail-activityContainer")
        self.activity = Activity(rawValue: try activityElement.text())
        
        self.name = try element.select("p.NordicDetail-pisteName").text()
            .replacingOccurrences(of: "- Raquettes", with: "")
        
        self.info = try element.select("div.NordicDetail-iconInfo").attr("data-comment")
        
        if let difficultyLabel = try element.select("svg.NordicDetail-pisteIcon").select("use").attr("xlink:href").split(separator: "-").last {
            self.difficulty = Difficulty(rawValue: String(difficultyLabel))
        } else {
            self.difficulty = nil
        }
        
        if let statusLabel = try element.select("span.NordicDetail-pisteOuverture").text().split(separator: " ").first {
            self.status = Status(rawValue: String(statusLabel))
        } else {
            self.status = nil
        }
        
        if let lengthLabel = try element.select("p.NordicDetail-pisteActivity").text().split(separator: "k").first, let km = Double(lengthLabel) {
            self._length = Int(km * 1000)
        } else {
            self._length = nil
        }
        
        self.metadata = TrackMetadata(name: name)
        self.id = name
    }
}
