import Foundation
import MapKit

#if os(iOS)
import Mapbox

class MapViewCoordinator: NSObject, MGLMapViewDelegate {
    var mapViewController: MapView!
    var trackOverlayColor: UIColor = UIColor.systemBlue

    init(mapView: MapView) {
        self.mapViewController = mapView
        super.init()
    }

    func mapView(_ mapView: MGLMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        return MKOverlayRenderer()
    }
}
#endif
