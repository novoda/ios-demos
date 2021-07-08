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
    func hasPositionChanged(comparedTo animationInfo: AnimationInfo) -> Bool {
        return !simd_equal(animationInfo.finalModelPosition, self.simdWorldPosition)
    }

    func hasOrientationChanged(comparedTo animationInfo: AnimationInfo) -> Bool {
        return animationInfo.finalModelRotation != self.simdWorldOrientation
    }
}
