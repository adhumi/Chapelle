import SwiftUI

#if os(xrOS)
import RealityKit
import Combine

/// A view that displays a 360 degree scene in which to watch video.
struct ImmersiveWebcamView: View {
    var body: some View {
        RealityView { content in
            let rootEntity = Entity()
            try! rootEntity.addSkybox()
            content.add(rootEntity)
        }
        .transition(.opacity)
    }
}

extension Entity {
    func addSkybox() throws {
        let texture = try TextureResource.load(named: "static-cam")
        var material = UnlitMaterial()
        material.color = .init(texture: .init(texture))
        self.components.set(ModelComponent(mesh: .generateSphere(radius: 1E3), materials: [material]))
        self.scale *= .init(x: -1, y: 1, z: 1)
        self.transform.translation += SIMD3<Float>(0.0, 1.0, 0.0)
        
        updateRotation()
    }
    
    func updateRotation() {
        // Rotate the immersive space around the Y-axis set the user's
        // initial view of the immersive scene.
        let angle = Angle.degrees(90)
        let rotation = simd_quatf(angle: Float(angle.radians), axis: SIMD3<Float>(0, 1, 0))
        self.transform.rotation = rotation
    }
}
#endif
