import SwiftUI

@available(iOS 16.0, *)
struct DailyWeatherView: View {
    private struct FormattedForecast: Identifiable {
        let id: String
        let time: String
        let weather: WeatherCondition?
        let temperature: String
        let temperatureValue: Double
        let precipitations: String
        let windFromDirection: Double
        let windSpeed: String
        
        init(forecast: Weather.Forecast) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH"
            
            let next: Weather.Forecast.Next
            if let sky = forecast.next1Hour.sky {
                next = forecast.next1Hour
                self.weather = sky
                
                self.time = dateFormatter.string(from: forecast.time) + " h"
self.id = self.time
            } else {
                next = forecast.next6Hours
                self.weather = forecast.next6Hours.sky
                
                self.time = dateFormatter.string(from: forecast.time) + "–" + dateFormatter.string(from: forecast.time.addingTimeInterval(3600 * 6)) + " h"
                self.id = self.time
            }
            
            if let min = next.airTemperatureMin, let max = next.airTemperatureMax {
                self.temperatureValue = round((min + max) * 0.5)
            } else {
                self.temperatureValue = round(forecast.current.airTemperature)
            }
            self.temperature = String(format: "%d°", Int(self.temperatureValue))
            
            if let precipitationsAmount = next.precipitationAmount, precipitationsAmount > 0 {
                self.precipitations = String(format: "%.1f mm", precipitationsAmount)
            } else {
                self.precipitations = ""
            }
            
            self.windFromDirection = forecast.current.windFromDirection
            self.windSpeed = String(format: "%.f m/s", round(forecast.current.windSpeed))
        }
    }
    
    @Binding var showModal: Bool
    
    let date: Date
    private let forecasts: [FormattedForecast]
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    init(showModal: Binding<Bool>, date: Date, forecasts: [Weather.Forecast]) {
        self._showModal = showModal
        self.date = date
        self.forecasts = forecasts.map {
            FormattedForecast(forecast: $0)
        }
    }
        
    var body: some View {
        NavigationView {
            ScrollView {
                Grid() {
                    GridRow {
                        Text("Heure")
                            .font(.footnote)
                            .foregroundColor(.secondary)

                        Text("Ciel")
                            .font(.footnote)
                            .foregroundColor(.secondary)

                        Text("Temp.")
                            .font(.footnote)
                            .foregroundColor(.secondary)

                        Text("Précip.")
                            .font(.footnote)
                            .foregroundColor(.secondary)

                        Text("Vent")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                    
                    ForEach(forecasts) { forecast in
                        Divider()
                        
                        GridRow {
                            Text(forecast.time)
                                .font(.subheadline)
                            
                            forecast.weather?.icon
                                .resizable()
                                .frame(width: 35, height: 35)
                            
                            Text(forecast.temperature)
                                .font(.subheadline)
                                .foregroundColor(forecast.temperatureValue > 0 ? Color.red : Color.blue)
                            
                            Text(forecast.precipitations)
                                .font(.subheadline)
                                .foregroundColor(.teal)
                                                        
                            HStack {
                                Image(systemName: "arrow.up")
                                    .rotationEffect(Angle(degrees: forecast.windFromDirection + 180))
                                    .font(Font.footnote)
                                Text(forecast.windSpeed)
                            }
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(dateFormatter.string(from: date))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showModal = false
                    } label: {
                        Label("Close", systemImage: "xmark")
                    }
                }
            }
        }
    }
}
