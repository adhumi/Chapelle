import SwiftUI

struct WeatherService {
    func fetchWeather() async throws -> Weather {
        let url = URL(string: "https://api.met.no/weatherapi/locationforecast/2.0/complete?lat=46.599998&lon=6.116667")!
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        
        let forecast = try decoder.decode(YRForecast.self, from: data)
        return forecast.simpleWeather
    }
}
