//
//  ChapelleWidget.swift
//  ChapelleWidget
//
//  Created by Adrien Humilière on 13/02/2023.
//

import WidgetKit
import SwiftUI
import UIKit
import SwiftSoup

struct Provider: TimelineProvider {
    let weatherService = WeatherService()
    let nordicFranceService = NordicFranceService()
    
    func placeholder(in context: Context) -> Entry {
        return Entry(date: Date(), imageData: NSDataAsset(name: "fake-webcam")!.data, forecast: nil, snowStatus: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> ()) {
        let entry = Entry(date: Date(), imageData: NSDataAsset(name: "fake-webcam")!.data, forecast: nil, snowStatus: nil)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        Task(priority: .background, operation: {
            let webcamURL = URL(string: "https://srv06.trinum.com/ibox/ftpcam/val-de-mouthe_chapelle-des-bois.jpg")!
            let (data, _) = try await URLSession.shared.data(from: webcamURL)
            
            let weather = try? await weatherService.fetchWeather()
            
            let html = try? await nordicFranceService.fetchWebpage()
            let snowStatus = try? parseSnowStatus(html)
            
            let entry = Entry(date: Date(),
                              imageData: data,
                              forecast: weather,
                              snowStatus: snowStatus)
            
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        })
    }
    
    private func parseSnowStatus(_ dom: Document?) throws -> SnowStatus? {
        guard let dom = dom else { return nil }
        guard let snowStatusElement = try dom.select("div.NordicDetail-neigeContainer").first() else { return nil }

        return try SnowStatus(element: snowStatusElement)
    }
}

struct Entry: TimelineEntry {
    var date: Date
    
    let imageData: Data?
    let forecast: Weather?
    let snowStatus: SnowStatus?
}



struct ChapelleWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var family

    var body: some View {
        ZStack {
            if let imageData = entry.imageData, let image = UIImage(data: imageData) {
                GeometryReader { geo in
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                }
            }
            
            
        }
        .overlay(alignment: .bottom) {
            if family == .systemSmall {
                HStack {
                    VStack(alignment: .leading) {
                        forecastView
                        snowStatusView
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Gradient(colors: [.black.opacity(0), .black.opacity(0.4), .black.opacity(0.6), .black.opacity(0.6)]))
            } else {
                HStack {
                    forecastView
                    Spacer()
                    snowStatusView
                }
                .padding()
                .background(Gradient(colors: [.black.opacity(0), .black.opacity(0.4), .black.opacity(0.6)]))
            }
        }
        .overlay(alignment: .topTrailing) {
            weatherIcon
                .padding(10)
        }
    }
    
    @ViewBuilder
    var forecastView: some View {
        if let forecast = entry.forecast?.forecasts.first, let temperatureMin = forecast.next6Hours.airTemperatureMin, let temperatureMax = forecast.next6Hours.airTemperatureMax {
            Label("\(Int(temperatureMin))° · \(Int(temperatureMax))°", systemImage: "thermometer.medium")
                .font(.subheadline)
                .foregroundColor(.white)
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder
    var snowStatusView: some View {
        if let snowStatus = entry.snowStatus, let minHeight = snowStatus.minHeight, let maxHeight = snowStatus.maxHeight {
            Label("\(minHeight) à \(maxHeight) cm", systemImage: "snowflake")
                .font(.subheadline)
                .foregroundColor(.white)
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder
    var weatherIcon: some View {
        if let sky = entry.forecast?.forecasts.first?.next6Hours.sky {
            sky.icon
                .resizable()
                .frame(width: 30, height: 30)
        } else {
            EmptyView()
        }
    }
}

struct ChapelleWidget: Widget {
    let kind: String = "ChapelleWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ChapelleWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Chapelle des Bois")
        .description("Pour garder un œil sur le départ des pistes, la météo et la hauteur de neige.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])

    }
}

struct ChapelleWidget_Previews: PreviewProvider {
    static var previews: some View {
        ChapelleWidgetEntryView(entry: Entry(date: Date(), imageData: NSDataAsset(name: "fake-webcam")!.data, forecast: nil, snowStatus: nil))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        
        ChapelleWidgetEntryView(entry: Entry(date: Date(), imageData: NSDataAsset(name: "fake-webcam")!.data, forecast: nil, snowStatus: nil))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        
        ChapelleWidgetEntryView(entry: Entry(date: Date(), imageData: NSDataAsset(name: "fake-webcam")!.data, forecast: nil, snowStatus: nil))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
