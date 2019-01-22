import UIKit
import SceneKit
import ARKit

extension SCNGeometry {
    func styleFirstMaterial(with material: Any) {
        self.firstMaterial?.diffuse.contents = material
    }
}

extension ARImageAnchor {
    func imageSize() -> CGSize {
        return self.referenceImage.physicalSize
    }
}

extension SCNNode {
    func opacitySlightlyTransparent() {
        self.opacity = self.opacity * 0.95
    }

    func positionYSmallOffset() {
        self.position.y = self.position.y + 0.01
    }
}
