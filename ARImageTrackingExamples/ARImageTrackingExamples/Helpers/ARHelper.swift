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
