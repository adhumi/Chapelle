import Foundation
import CoreLocation
import SwiftUI

struct ElevationChartPoint: Equatable, Identifiable {
    var id: String {
        return String(distance)
    }
    
    let distance: Double
    let elevation: Double
}

struct ElevationChartShape: Shape {
    let waypoints: [Waypoint]
    let points: [ElevationChartPoint]
    
    let pointSize: CGFloat
    let minValue: Double
    let maxValue: Double
    
    init(waypoints: [Waypoint], pointSize: CGFloat = 2) {
        self.waypoints = waypoints
        self.points = waypoints.elevationChartPoints()
        self.pointSize = pointSize
        self.minValue = points.lowestPoint()?.elevation ?? 1
        self.maxValue = points.highestPoint()?.elevation ?? 1
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let drawRect = rect.inset(by: UIEdgeInsets(top: pointSize,
                                                   left: 0,
                                                   bottom: 20,
                                                   right: 0))

        let xMultiplier = drawRect.width / CGFloat(points.last?.distance ?? 1)
        let yMultiplier = drawRect.height / CGFloat(maxValue - minValue)
        
        for point in points {
            var x = xMultiplier * CGFloat(point.distance)
            var y = yMultiplier * CGFloat(point.elevation - minValue)

            y = drawRect.height - y
            
            x += drawRect.minX
            y += drawRect.minY
            
            if point == points.first {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        return path
    }
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
