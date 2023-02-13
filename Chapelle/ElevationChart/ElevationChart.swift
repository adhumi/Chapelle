import SwiftUI

struct ElevationChart: View {
    let waypoints: [Waypoint]
    
    var body: some View {
        ZStack {
            ElevationChartFillShape(waypoints: waypoints, pointSize: 2)
                .fill(LinearGradient(gradient: Gradient(colors: [.cyan, .cyan.opacity(0)]),
                                     startPoint: .top,
                                     endPoint: .bottom))
            ElevationChartShape(waypoints: waypoints, pointSize: 2)
                .stroke(.blue, lineWidth: 2)
        }
    }
}
