import SwiftUI
import MapKit
import Charts

struct TrackView: View {
    var nordicFranceTrack: NordicFranceTrack
    
    var distanceFormatter: MKDistanceFormatter = {
        let formatter = MKDistanceFormatter()
        formatter.unitStyle = .abbreviated
        return formatter
    }()
    
    var trackColor: Color {
        nordicFranceTrack.difficulty?.color ?? Color.teal
    }
    
    var body: some View {
        ScrollView {
            #if os(iOS)
            if let track = TrackMetadata(name: nordicFranceTrack.name), track.gpxPath != nil {
                MapView(track: track, color: trackColor)
                    .frame(height: 250)
            }
            #endif
            
            HStack {
                VStack(alignment: .leading) {
                    if let status = nordicFranceTrack.status {
                        Label(status.description, systemImage: status.systemImageName)
                            .font(.subheadline)
                            .foregroundColor(status.color)
                    }
                    
                    Text(nordicFranceTrack.name)
                        .font(.title.bold())
                }
                
                Spacer()
            }
            .padding()
            
            HStack(alignment: .top, spacing: 8) {
                if let length = nordicFranceTrack.length {
                    cartridge(title: "Distance", value: distanceFormatter.string(fromDistance: CLLocationDistance(length)))
                }
                
                if let denivelation = nordicFranceTrack.metadata?.denivelation {
                    cartridge(title: "Dénivelé", value: "\(denivelation) D+")
                }
                
                if let difficulty = nordicFranceTrack.difficulty {
                    cartridge(title: "Difficulté", value: difficulty.description, color: difficulty.color)
                }
            }
            .padding(.horizontal)
            
            if let metadata = nordicFranceTrack.metadata, let gpxPath = metadata.gpxPath, let waypoints = try? GPXParser().parseWaypoints(from: gpxPath) {
                if #available(iOS 16.0, *) {
                    elevationChartForIOS16(waypoints: waypoints)
                } else {
                    elevationChartForIOS15(waypoints: waypoints)
                }
            }
            
//            // Remove as Nordic France data is not up to date
//            if let info = nordicFranceTrack.info, !info.isEmpty {
//                HStack(alignment: .top, spacing: 8) {
//                    Image(systemName: "info.circle")
//                        .symbolRenderingMode(.hierarchical)
//                        .foregroundColor(.blue)
//
//                    Text(info)
//                        .font(.subheadline)
//                }
//                .padding()
//                .background(.ultraThinMaterial)
//                .cornerRadius(8)
//                .padding()
//            }
            
        }
        .navigationBarTitleDisplayMode(.inline)
            
    }
    
    @available(iOS 16.0, *)
    @ViewBuilder
    func elevationChartForIOS16(waypoints: [Waypoint]) -> some View {
        let elevationChartPoints = waypoints.elevationChartPoints()
        let minElevation = (elevationChartPoints.lowestPoint()?.elevation ?? 900)
        let maxElevation = (elevationChartPoints.highestPoint()?.elevation ?? 1300)
        if let lastPoint = elevationChartPoints.last {
            Chart(waypoints.elevationChartPoints()) { waypoint in
                AreaMark(
                    x: .value("Distance", waypoint.distance / 1000),
                    yStart: .value("Altitude", minElevation - 20),
                    yEnd: .value("Altitude", waypoint.elevation)
                )
            }
            .clipped()
            .foregroundStyle(trackColor.opacity(0.8))
            .chartXAxisLabel("Distance (km)")
            .chartYAxisLabel("Altitude (m)")
            .chartXScale(domain: 0...lastPoint.distance/1000)
            .chartYScale(domain: minElevation - 20...maxElevation, type: .linear)
            .padding()
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(UIColor.lightGray), lineWidth: 1)
            )
            .padding(.horizontal)
        } else {
            EmptyView()
        }
    }
    
    func elevationChartForIOS15(waypoints: [Waypoint]) -> some View {
        ElevationChart(waypoints: waypoints)
            .frame(height: 100)
            .padding(.top)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(UIColor.lightGray), lineWidth: 1)
            )
            .padding()
    }
    
    func cartridge(title: String, value: String, color: Color? = .primary) -> some View {
        VStack {
            Text(title)
                .font(.footnote)
            Text(value)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(color)
            
        }
        .padding(8)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .cornerRadius(8)
    }
}

struct TrackView_Preview: PreviewProvider {
    static var previews: some View {
        TrackView(nordicFranceTrack: NordicFranceTrack(activity: .xcSkiing,
                               name: "Chalet Pin",
                               info: nil,
                               difficulty: .red,
                                                       status: .opened,
                                                       length: nil))
    }
}
