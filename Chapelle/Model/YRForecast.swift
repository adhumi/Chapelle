import Foundation

struct YRForecast: Codable {
    struct Properties: Codable {
        struct Meta: Codable {
            let units: [String: String]
            let updatedAt: Date
        }
        
        struct Timeserie: Codable {
            struct Data: Codable {
                struct Instant: Codable {
                    struct Details: Codable {
                        let airPressureAtSeaLevel: Double
                        let airTemperature: Double
                        let cloudAreaFraction: Double
                        let cloudAreaFractionHigh: Double?
                        let cloudAreaFractionLow: Double?
                        let cloudAreaFractionMedium: Double?
                        let dewPointTemperature: Double?
                        let fogAreaFraction: Double?
                        let relativeHumidity: Double
                        let ultravioletIndexClearSky: Double?
                        let windFromDirection: Double
                        let windSpeed: Double
                    }
                    
                    let details: Details
                }
                
                struct Next: Codable {
                    struct Details: Codable {
                        let precipitationAmount: Double?
                        let precipitationAmountMin: Double?
                        let precipitationAmountMax: Double?
                        let probabilityOfPrecipitation: Double?
                        let airTemperatureMin: Double?
                        let airTemperatureMax: Double?
                        let probabilityOfThunder: Double?
                        let ultravioletIndexClearSkyMax: Double?
                    }
                    
                    struct Summary: Codable {
                        // https://api.met.no/weatherapi/weathericon/2.0/documentation#List_of_symbols
                        let symbolCode: String
                    }
                    
                    let details: Details?
                    let summary: Summary
                }
                
                let instant: Instant
                let next1Hours: Next?
                let next6Hours: Next?
                let next12Hours: Next?
            }
            
            let data: Data
            let time: Date
        }
        
        let meta: Meta
        let timeseries: [Timeserie]
    }
    
    let properties: Properties
}
