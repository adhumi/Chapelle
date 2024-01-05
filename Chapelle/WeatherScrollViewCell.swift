import SwiftUI

struct WeatherScrollViewCell: View {
    let weather: Weather
    let forecast: Weather.Forecast
    
    @State var detailsPresented: Bool = false
    
    var body: some View {
        Button {
            self.detailsPresented = true
        } label: {
            dailyWeatherView(forecast: forecast)
        }
        .sheet(isPresented: $detailsPresented) {
            if #available(iOS 16.0, *) {
                DailyWeatherView(showModal: $detailsPresented, date: forecast.time, forecasts: weather.forecasts(for: forecast.time))
            }
        }
    }
    
    func dailyWeatherView(forecast: Weather.Forecast) -> some View {
        VStack(alignment: .center, spacing: 2) {
            dateText(forecast.time)
                .padding(.horizontal, 4)
                .font(.subheadline.bold())
                .foregroundColor(.secondary)
            
            forecast.next12Hours.sky?.icon
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            
            HStack(alignment: .center, spacing: 12) {
                if let min = forecast.next12Hours.airTemperatureMin {
                    Label("\(Int(min))°", systemImage: "thermometer.snowflake")
                        .font(.subheadline)
                        .foregroundColor(.cyan)
                        .labelStyle(.titleOnly)
                }
                
                if let max = forecast.next12Hours.airTemperatureMax {
                    Label("\(Int(max))°", systemImage: "thermometer.sun")
                        .font(.subheadline)
                        .foregroundColor(.red)
                        .labelStyle(.titleOnly)
                }
            }
            .padding(.top, 4)
            
            Label {
                Text("\(Int(forecast.current.windSpeed)) m/s")
            } icon: {
                Image(systemName: "arrow.up")
                    .rotationEffect(Angle(degrees: forecast.current.windFromDirection + 180))
                    .font(Font.caption)
            }
            .font(.footnote)
            .foregroundColor(.secondary)
            
            if let precipitation = forecast.next12Hours.precipitationAmount, precipitation >= 1 {
                Label("\(Int(precipitation)) mm", systemImage: "drop")
                    .font(.footnote)
                    .labelStyle(.titleOnly)
                    .foregroundColor(.blue)
            } else if let precipitation = forecast.next12Hours.precipitationAmount, precipitation > 0 {
                Label(String(format: "%.1f mm", precipitation), systemImage: "drop")
                    .font(.footnote)
                    .labelStyle(.titleOnly)
                    .foregroundColor(.blue)
            } else {
                Label("", systemImage: "drop")
                    .font(.footnote)
                    .labelStyle(.titleOnly)
            }
        }
        .frame(minWidth: 80, maxHeight: .infinity)
    }
    
    func dateText(_ date: Date) -> some View {
        if date.isToday || date.isTommorow {
            return Text(date, formatter: Self.weatherRelativeDateFormatter)
        } else {
            return Text(date, formatter: Self.weatherDateFormatter)
        }
    }
    
    static let weatherRelativeDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.doesRelativeDateFormatting = true
        formatter.timeStyle = .none
        formatter.formattingContext = .listItem
        return formatter
    }()
    
    static let weatherDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.formattingContext = .listItem
        return formatter
    }()
}
