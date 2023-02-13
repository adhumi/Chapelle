import Foundation
import CoreLocation
import SwiftUI

struct ElevationChartFillShape: Shape {
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
            if point == points.first {
                path.move(to: CGPoint(x: 0, y: rect.height))
            }
            
            var x = xMultiplier * CGFloat(point.distance)
            var y = yMultiplier * CGFloat(point.elevation - minValue)

            y = drawRect.height - y
            
            x += drawRect.minX
            y += drawRect.minY
            
            path.addLine(to: CGPoint(x: point == points.first ? 0 : x,
                                     y: y))
            
            if point == points.last {
                path.addLine(to: CGPoint(x: x, y: rect.height))
            }
        }
        
        return path
    }
}
