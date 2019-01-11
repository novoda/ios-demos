import UIKit
import SceneKit

extension SCNGeometry {
    func styleFirstMaterial(with material: Any) {
        self.firstMaterial?.diffuse.contents = material
    }
}

