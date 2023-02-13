import Foundation

struct Weather {
    struct Forecast {
        struct Details {
            let airPressureAtSeaLevel: Double
            let airTemperature: Double
            let windFromDirection: Double
            let windSpeed: Double
        }
        
        struct Next {
            let sky: WeatherCondition?
            let precipitationAmount: Double?
            let airTemperatureMin: Double?
            let airTemperatureMax: Double?
        }
        
        let time: Date
        let current: Details
        let next6Hours: Next
        let next12Hours: Next
    }
    
    let updatedAt: Date
    let forecasts: [Forecast]
}

extension Weather {
    
    var nextMorningForecast: Forecast? {
        forecasts.first {
            guard let hour = Calendar.current.dateComponents([.hour], from: $0.time).hour else { return false }
            return hour == 8
        }
    }
    
    func dailyForecasts(at time: Int = 6) -> [Forecast] {
        return forecasts.enumerated().compactMap { (index, forecast) in
            let dateComponents = Calendar.current.dateComponents(in: TimeZone(secondsFromGMT: 0)!, from: forecast.time)
            guard let hour = dateComponents.hour else { return nil }
            
            if index == 0 && hour > time {
                return forecast
            }
            
            return hour == time ? forecast : nil
        }
    }
}

extension Weather.Forecast: Identifiable {
    var id: ObjectIdentifier {
        return ObjectIdentifier(time as NSDate)
    }
}

extension YRForecast {
    var simpleWeather: Weather {
        return Weather(updatedAt: properties.meta.updatedAt,
                       forecasts: properties.timeseries.map {
            Weather.Forecast(time: $0.time,
                             current: Weather.Forecast.Details(airPressureAtSeaLevel: $0.data.instant.details.airPressureAtSeaLevel,
                                                               airTemperature: $0.data.instant.details.airTemperature,
                                                               windFromDirection: $0.data.instant.details.windFromDirection,
                                                               windSpeed: $0.data.instant.details.windSpeed),
                             next6Hours: Weather.Forecast.Next(sky: WeatherCondition(rawValue: $0.data.next6Hours?.summary.symbolCode ?? ""),
                                                               precipitationAmount: $0.data.next6Hours?.details?.precipitationAmount,
                                                               airTemperatureMin: $0.data.next6Hours?.details?.airTemperatureMin,
                                                               airTemperatureMax: $0.data.next6Hours?.details?.airTemperatureMax),
                             next12Hours: Weather.Forecast.Next(sky: WeatherCondition(rawValue: $0.data.next6Hours?.summary.symbolCode ?? ""),
                                                                precipitationAmount: $0.data.next6Hours?.details?.precipitationAmount,
                                                                airTemperatureMin: $0.data.next6Hours?.details?.airTemperatureMin,
                                                                airTemperatureMax: $0.data.next6Hours?.details?.airTemperatureMax)
                             )
        })
    }
}
