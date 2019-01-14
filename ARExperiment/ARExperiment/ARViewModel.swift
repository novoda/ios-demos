import Foundation
import SceneKit
import ARKit

class ARViewModel {

    private var sceneForView: SCNScene?

    init(arAsset: ARAsset) {
        guard let scene = SCNScene(named: arAsset.filePath()) else {
            return
        }
        self.sceneForView = scene
    }

    func createSceneNodeForAsset(_ nodeName: String) -> SCNNode? {
        guard let scene = sceneForView else {
            return nil
        }
        let node = scene.rootNode.childNode(withName: nodeName, recursively: true)
        return node
    }

    func worldTransformForAnchor(at location: CGPoint, in sceneView: ARSCNView, withType type: ARHitTestResult.ResultType) -> simd_float4x4? {
        guard let hitPoint = hitResult(at: location,
                                       in: sceneView,
                                       withType: type) else {
                                            print("failed to find hit point")
                                            return nil
        }
        guard let currentFrame = sceneView.session.currentFrame else {
            print("failed to find current frame on scene")
            return nil
        }
        let rotate = simd_float4x4(SCNMatrix4MakeRotation(currentFrame.camera.eulerAngles.y, 0, 1, 0))
        return simd_mul(hitPoint.worldTransform, rotate)
    }

    func hitResult(at location: CGPoint, in sceneView: ARSCNView, withType type: ARHitTestResult.ResultType) -> ARHitTestResult? {
        let hitResultsFeaturePoints: [ARHitTestResult] = sceneView.hitTest(location, types: type)
        return hitResultsFeaturePoints.first
    }

    private func createAssetPath(assetFolder: String?, fileName: String, fileExtension: String) -> String {
        if let assetFolder = assetFolder {
            return "art.scnassets/\(assetFolder)/\(fileName).\(fileExtension)"
        }
        return "art.scnassets/\(fileName).\(fileExtension)"
    }
}
extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}
