import Foundation

enum Activity: String, CaseIterable, Identifiable {
    case xcSkiing = "Ski de fond"
    case snowshoe = "Raquettes"
    case sled = "Luge"
    
    var id: Self { self }
    
    var activityTracksLabel: String {
        switch self {
            case .xcSkiing:
                return "Pistes de ski de fond"
            case .snowshoe:
                return "Pistes de raquettes"
            case .sled:
                return "Pistes de luge"
        }
    }
    
    var iconName: String {
        switch self {
            case .xcSkiing:
                return "xc-skiing"
            case .snowshoe:
                return "snowshoes"
            case .sled:
                return "sledge"
        }
    }
}
