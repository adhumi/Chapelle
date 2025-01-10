import SwiftUI

struct WeatherScrollView: View {
    let weather: Weather
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(weather.dailyForecasts()) { forecast in
                    if forecast.next12Hours.sky != nil {
                        WeatherScrollViewCell(weather: weather, forecast: forecast)
                    }
                }
            }
        }
    }
}

