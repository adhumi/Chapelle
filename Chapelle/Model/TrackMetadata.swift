import Foundation

enum TrackMetadata: String {
    case pisteEclairee
    case beauregard
    case beurriere
    case loge
    case tourDuVillage
    case chaumoz
    case combeVerte
    case jobez
    case cernee
    case norbiere
    case nondance
    case chezMichel
    case combeDesCives
    case chaletPin
    case mortes
    case presDHaut
    case greffier
    
    init?(name: String) {
        switch name {
            case "Piste éclairée Chapelle des Bois":
                self = .pisteEclairee
            case "Beauregard":
                self = .beauregard
            case "La Beurrière":
                self = .beurriere
            case "La Loge":
                self = .loge
            case "Le Tour du Village":
                self = .tourDuVillage
            case "Chaumoz":
                self = .chaumoz
            case "Combe Verte":
                self = .combeVerte
            case "Jobez":
                self = .jobez
            case "La Cernée":
                self = .cernee
            case "La Norbière":
                self = .norbiere
            case "Nondance":
                self = .nondance
            case "Chez Michel":
                self = .chezMichel
            case "Combe des Cives":
                self = .combeDesCives
            case "Chalet Pin":
                self = .chaletPin
            case "Les Mortes":
                self = .mortes
            case "Les Prés D'Haut":
                self = .presDHaut
            case "Greffier":
                self = .greffier
            default:
                return nil
        }
    }
    
    var gpxPath: String? {
        return Bundle.main.path(forResource: rawValue, ofType: "gpx")
    }
    
    var stravaSegment: String {
        switch self {
            case.pisteEclairee:
                return ""
            case .beauregard:
                return ""
            case .beurriere:
                return "17081407"
            case .loge:
                return ""
            case .tourDuVillage:
                return ""
            case .chaumoz:
                return ""
            case .combeVerte:
                return "11221322"
            case .jobez:
                return "6757330"
            case .cernee:
                return ""
            case .norbiere:
                return ""
            case .nondance:
                return "11625911"
            case .chezMichel:
                return ""
            case .combeDesCives:
                return ""
            case .chaletPin:
                return "8996090"
            case .mortes:
                return ""
            case .presDHaut:
                return ""
            case .greffier:
                return ""
        }
    }
    
    var length: Int { // Meters
        switch self {
            case .pisteEclairee: return 1220
            case .beauregard: return 2000
            case .beurriere: return 3490
            case .loge: return 4490
            case .tourDuVillage: return 4500
            case .chaumoz: return 9910
            case .combeVerte: return 8230
            case .jobez: return 5640
            case .cernee: return 8000
            case .norbiere: return 8180
            case .nondance: return 4910
            case .chezMichel: return 8780
            case .combeDesCives: return 9000
            case .chaletPin: return 10810
            case .mortes: return 13360
            case .presDHaut: return 14300
            case .greffier: return 14740
        }
    }
    
    
    var denivelation: Int? { // Meters
        switch self {
            case .pisteEclairee: return 25
            case .beauregard: return nil
            case .beurriere: return 59
            case .loge: return 49
            case .tourDuVillage: return nil
            case .chaumoz: return 145
            case .combeVerte: return 136
            case .jobez: return 91
            case .cernee: return nil
            case .norbiere: return 123
            case .nondance: return 70
            case .chezMichel: return 146
            case .combeDesCives: return nil
            case .chaletPin: return 187
            case .mortes: return 225
            case .presDHaut: return 344
            case .greffier: return 250
        }
    }
}
