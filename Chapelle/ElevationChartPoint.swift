import Foundation
import CoreLocation

struct ElevationChartPoint: Equatable, Identifiable {
    var id: String {
        return String(distance)
    }
    
    let distance: Double
    let elevation: Double
}

extension Array where Element == Waypoint {
    func elevationChartPoints() -> [ElevationChartPoint] {
        var points: [ElevationChartPoint] = []
        var traveledDistance: Double = 0
        var previousPoint: Waypoint? = nil
        
        for waypoint in self {
            if let previousPoint = previousPoint {
                traveledDistance += previousPoint.coordinates.distance(to: waypoint.coordinates)
            }
            
            points.append(.init(distance: traveledDistance, elevation: waypoint.elevation))
            previousPoint = waypoint
        }
        
        return points
    }
}

extension Array where Element == ElevationChartPoint {
    func highestPoint() -> ElevationChartPoint? {
        return self.max { $0.elevation < $1.elevation }
    }
    
    func lowestPoint() -> ElevationChartPoint? {
        return self.min { $0.elevation < $1.elevation }
    }
}

extension CLLocationCoordinate2D {
    func distance(to: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return from.distance(from: to)
    }
}
