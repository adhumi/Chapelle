import SwiftUI
#if os(iOS)
import UIKit
import Mapbox
import MapKit
import Foundation

struct MapView: UIViewRepresentable {
    let track: TrackMetadata
    let color: Color
    
    init(track: TrackMetadata, color: Color) {
        self.track = track
        self.color = color
    }
    
    func makeCoordinator() -> MapViewCoordinator {
        let coordinator = MapViewCoordinator(mapView: self)
        coordinator.trackOverlayColor = UIColor(color)
        return coordinator
    }

    func makeUIView(context: Context) -> MGLMapView {
        let mapTilerKey = "mcV7vy8NaEh6o9rAxgDm"
        let styleURL = URL(string: "https://api.maptiler.com/maps/04917ed6-57c3-46d4-9d63-4ad478a409cd/style.json?key=\(mapTilerKey)")
        
        // create the mapview
        let mapView = MGLMapView(frame: .zero, styleURL: styleURL)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.logoView.isHidden = true
        mapView.setCenter(
            CLLocationCoordinate2D(latitude: 46.602915, longitude: 6.112687),
            zoomLevel: 13,
            animated: false)
        mapView.tintColor = UIColor(color)
        
        // use the coordinator only if you need
        // to respond to the map events
        mapView.delegate = context.coordinator
        
        return mapView
    }
    
    func updateUIView(_ view: MGLMapView, context: Context){
        view.delegate = context.coordinator
        
        if let polyline = track.polyline() {
            addRoute(polyline, to: view)
            view.setVisibleCoordinateBounds(polyline.surroundingRegion(), animated: false)
        }
    }
}
#endif
