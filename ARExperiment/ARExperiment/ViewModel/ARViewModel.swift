import Foundation
import SceneKit
import ARKit

class ARViewModel {

    private let arAsset: ARAsset

    init(arAsset: ARAsset) {
        self.arAsset = arAsset
    }

    func nodesForARExperience(using lightEstimate: ARLightEstimate) -> [SCNNode] {
        var nodes: [SCNNode] = []

        for node in arAsset.nodesOfType(.model) {
            if let modelNode = createSceneNodeForAsset(node.name) {
                nodes.append(modelNode)
            }
        }

        for node in arAsset.nodesOfType(.light) {
            if let lightNode = createSceneNodeForAsset(node.name) {
                lightNode.defaultLightConfiguration(with: lightEstimate)
                nodes.append(lightNode)
            }
        }

        for node in arAsset.nodesOfType(.plane) {
            if let planeNode = createSceneNodeForAsset(node.name) {
                planeNode.defaultTransparentPlane()
                nodes.append(planeNode)
            }
        }

        return nodes
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

    func node(in sceneView: ARSCNView, named nodeName: String) -> SCNNode? {
        return sceneView.scene.rootNode.childNode(withName: nodeName, recursively: true)
    }

    private func createSceneNodeForAsset(_ nodeName: String) -> SCNNode? {
        guard let scene = SCNScene(named: arAsset.filePath()) else {
            return nil
        }
        let node = scene.rootNode.childNode(withName: nodeName, recursively: true)
        return node
    }
}
extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}

private extension SCNNode {
    func defaultLightConfiguration(with estimate: ARLightEstimate) {
        guard let light: SCNLight = self.light else {
            return
        }
        light.intensity = estimate.ambientIntensity
        light.shadowMode = .deferred
        light.shadowSampleCount = 16
        light.shadowRadius = 24
    }

    func defaultTransparentPlane() {
        guard let plane = self.geometry else {
            return
        }
        plane.firstMaterial?.writesToDepthBuffer = true
        plane.firstMaterial?.colorBufferWriteMask = []
        plane.firstMaterial?.lightingModel = .constant
    }
}
