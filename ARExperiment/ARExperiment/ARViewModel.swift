import Foundation
import SceneKit
import ARKit

class ARViewModel {

    func createSceneNodeForAsset(_ assetName: String, assetPath: String) -> SCNNode? {
        guard let paperPlaneScene = SCNScene(named: assetPath) else {
            return nil
        }
        let carNode = paperPlaneScene.rootNode.childNode(withName: assetName, recursively: true)
        return carNode
    }

    func getHitResults(location: CGPoint, sceneView: ARSCNView) -> ARHitTestResult? {
        let hitResultsFeaturePoints: [ARHitTestResult] =
            sceneView.hitTest(location, types: [.existingPlaneUsingExtent, .estimatedHorizontalPlane])
        if let hit = hitResultsFeaturePoints.first {
            return hit
        }
        return nil
    }
}
extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}
