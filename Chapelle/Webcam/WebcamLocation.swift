import Foundation

enum WebcamLocation: String, CaseIterable, Identifiable {
    case chapelle
    case prePoncet
    case morbierMarais
    case morbierGlacier
    
    private var slug: String {
        switch self {
        case .chapelle:
            return "val-de-mouthe_chapelle-des-bois"
        case .prePoncet:
            return "val-de-mouthe_pre-poncet"
        case .morbierMarais:
            return "morbier_marais"
        case .morbierGlacier:
            return "morbier_les-glacieres"
        }
    }
    
    var name: String {
        switch self {
        case .chapelle:
            return "Départ des pistes"
        case .prePoncet:
            return "Pré Poncet"
        case .morbierMarais:
            return "Morbier – Les Marais"
        case .morbierGlacier:
            return "Morbier – Le Glacier"
        }
    }
    
    var liveURL: URL {
        return URL(string: "https://www.trinum.com/ibox/ftpcam/mega_\(slug).jpg")!
    }
    var liveThumbmailURL: URL {
        return URL(string: "https://www.trinum.com/ibox/ftpcam/small_\(slug).jpg")!
    }
    
    func dailyArchiveURL(for date: Date) -> URL {
        return URL(string: "https://archives.webcam-hd.com/\(DateFormatter.urlDateFormatter.string(from: date))/\(slug).json")!
    }
    
    func archivedImageURL(for date: Date, archive: ImageArchive) -> URL {
        return URL(string: "https://archives.webcam-hd.com/\(DateFormatter.urlDateFormatter.string(from: date))/\(archive.hourFolder)/\(slug)/html5/\(archive.imageHighResPath)")!
    }
    
    var shareURL: URL {
        return URL(string: "https://m.webcam-hd.com/espace-nordique-jurassien/\(slug)")!
    }
    
    var id: String {
        return self.rawValue
    }
}
