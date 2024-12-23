import Foundation
import SwiftSoup
import SwiftUI

@MainActor
class ContentVM: ObservableObject {
    @Published var tracks: [NordicFranceTrack] = []
    @Published var lastUpdate: String?
    @Published var snowStatus: SnowStatus?
    @Published var infoMessage: String?
    @Published var weather: Weather?
    
    let nordicFranceService = NordicFranceService()
    let weatherService = WeatherService()
    
    var areAllTracksClosed: Bool {
        return tracks.filter({ $0.status == .opened }).count > 0
    }
    
    init(tracks: [NordicFranceTrack] = [], lastUpdate: String? = nil, snowStatus: SnowStatus? = nil, infoMessage: String? = nil, weather: Weather? = nil) {
        self.tracks = tracks
        self.lastUpdate = lastUpdate
        self.snowStatus = snowStatus
        self.infoMessage = infoMessage
        self.weather = weather
        
        Task {
            await loadTracks()
            await loadWeather()
        }
    }
    
    func loadTracks() async {
        do {
            let dom = try await nordicFranceService.fetchWebpage()
            self.tracks = try parseTracks(dom)
            self.lastUpdate = try parseLastUpdate(dom)
            self.snowStatus = try parseSnowStatus(dom)
            self.infoMessage = try parseInfoMessage(dom)
        } catch (_) {
            
        }
    }
    
    func loadWeather() async {
        do {
            self.weather = try await weatherService.fetchWeather()
        } catch (_) {
            
        }
    }
    
    private func parseTracks(_ dom: Document) throws -> [NordicFranceTrack] {
        let tracksElements: Elements = try dom.select("div.NordicDetail-piste")
        let tracks = tracksElements.compactMap {
            try? NordicFranceTrack(element: $0)
        }
        return tracks.sorted {
            $0.difficulty?.sort ?? 9 < $1.difficulty?.sort ?? 9
        }
    }
    
    private func parseLastUpdate(_ dom: Document) throws -> String {
        return try dom.select("span.NordicDetail-damagelabel").text()
    }
    
    private func parseSnowStatus(_ dom: Document) throws -> SnowStatus? {
        guard let snowStatusElement = try dom.select("div.NordicDetail-neigeContainer").first() else { return nil }
        
        return try SnowStatus(element: snowStatusElement)
    }
    
    private func parseInfoMessage(_ dom: Document) throws -> String? {
        let info = try dom.select(".NordicDetail-secteurHeader div.NordicDetail-iconInfo").attr("data-comment")
        return info.isEmpty ? nil : info
    }
    
    func tracks(for activity: Activity) -> [NordicFranceTrack] {
        return tracks.filter {
            $0.activity == activity
        }
    }
    
    func welcomeMessage(withSnowStatus snowStatus: SnowStatus?) -> String {
        var message = "Bonjour 👋"
        var nextSeparator = "\n"
        
        weatherIf: if let weather = weather {
            guard let hour = Calendar.current.dateComponents([.hour], from: Date()).hour else { break weatherIf }
            
            message += nextSeparator
            
            switch hour {
            case 0...3, 17...24:
                guard let forecast = weather.nextMorningForecast else { break }
                guard let sky = forecast.next6Hours.sky, let temperatureMin = forecast.next6Hours.airTemperatureMin, let temperatureMax = forecast.next6Hours.airTemperatureMax else { break }

                    if temperatureMin.rounded() == temperatureMax.rounded() {
                        message += "Demain matin, \(sky.futureDescription) (\(Int(temperatureMin.rounded()))°C)."
                    } else {
                        message += "Demain matin, \(sky.futureDescription) (\(Int(temperatureMin.rounded())) à \(Int(temperatureMax.rounded()))°C)."
                    }
            default:
                guard let forecast = weather.forecasts.first else { break }
                guard let sky = forecast.next6Hours.sky else { break }
                
                    message += "\(sky.presentDescription) et il fait \(Int(forecast.current.airTemperature.rounded()))°C."
            }
            
            nextSeparator = " "
        }
        
        if let snowStatus = snowStatus {
            message += nextSeparator
            
            var snowQualityAdjective: String? = nil
            if let adjective = snowStatus.quality?.adjective {
                snowQualityAdjective = " \(adjective)"
            }
            
            if let minHeight = snowStatus.minHeight, let maxHeight = snowStatus.maxHeight, minHeight == maxHeight {
                message += "Il y a \(minHeight) cm de neige\(snowQualityAdjective ?? "")."
            } else if let minHeight = snowStatus.minHeight, let maxHeight = snowStatus.maxHeight {
                message += "Il y a \(minHeight) à \(maxHeight) cm de neige\(snowQualityAdjective ?? "")."
            } else if let minHeight = snowStatus.minHeight {
                message += "Il y a plus de \(minHeight) cm de neige\(snowQualityAdjective ?? "")."
            } else if let maxHeight = snowStatus.maxHeight {
                message += "Il y a jusqu'à \(maxHeight) cm de neige\(snowQualityAdjective ?? "")."
            }
            
            nextSeparator = " "
        }
        
        return message
    }
}
