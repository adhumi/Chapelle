import Foundation
import SwiftSoup
import SwiftUI

struct SnowStatus {
    enum Quality: String {
        case hard = "Dure"
        case soft = "Douce"
        case fresh = "Fraiche"
        case wet = "Humide"
        
        var adjective: String {
            switch self {
                case .hard:
                    return "dure"
                case .soft:
                    return "douce"
                case .fresh:
                    return "fraiche"
                case .wet:
                    return "humide"
            }
        }
    }
    
    var minHeight: Int?
    var maxHeight: Int?
    var quality: Quality?
    var updateDate: Date?
    
    init(element: Element) throws {
        let updateDateLabel = try element.select("span.NordicDetail-dateMaj").text()
        let heightLabel = try element.select("span.NordicDetail-neigeHeight").text()
        let qualityLabel = try element.select("span.NordicDetail-neigeLabel").text()
        
        dateLabelIf: if updateDateLabel.starts(with: "Mise à jour : ") {
            let dateLabel = updateDateLabel.replacingOccurrences(of: "Mise à jour : ", with: "")
            let components = dateLabel.split(separator: "/")
            
            guard let monthString = components.last, let month = Int(monthString) else { break dateLabelIf }
            guard let dayString = components.first, let day = Int(dayString) else { break dateLabelIf }
            
            let dateComponents = DateComponents(month: month, day: day, hour: 12) // Specify an hour to prevent timezone issues
            self.updateDate = Calendar.current.date(from: dateComponents)
        }
        
        heightLabelIf: if heightLabel.starts(with: "Hauteur de neige : ") {
            var troncatedHeightLabel = heightLabel.replacingOccurrences(of: "Hauteur de neige : ", with: "")
            troncatedHeightLabel = troncatedHeightLabel.replacingOccurrences(of: "cm", with: "")
            let components = troncatedHeightLabel.split(separator: "à")
            
            guard let minString = components.first?.replacingOccurrences(of: " ", with: ""), let min = Int(minString) else { break heightLabelIf }
            guard let maxString = components.last?.replacingOccurrences(of: " ", with: ""), let max = Int(maxString) else { break heightLabelIf }
            
            self.minHeight = min
            self.maxHeight = max
        }
        
        if qualityLabel.starts(with: "Qualité : ") {
            let troncatedQualityLabel = qualityLabel.replacingOccurrences(of: "Qualité : ", with: "")
            self.quality = Quality(rawValue: troncatedQualityLabel)
        }
    }
}
