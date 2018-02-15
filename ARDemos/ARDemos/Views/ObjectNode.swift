import UIKit
import ARKit
import SceneKit

class ObjectNode: SCNNode {

    func addObjectNode(nodeName: String, assetPath: String) {
        guard let node = getNodeFromScene(nodeName: nodeName, assetPath: assetPath) else {
            return
        }
        addChildNode(node)
    }

    func addLightNode(nodeName: String, assetPath: String, lightSettings: LightSetting?, lightEstimate: ARLightEstimate) {
        guard let node = getNodeFromScene(nodeName: nodeName, assetPath: assetPath),
                let lightSettings = lightSettings else {
            return
        }
        node.light?.intensity = lightEstimate.ambientIntensity
        node.light?.shadowMode = lightSettings.shadowMode.getMode()
        node.light?.shadowSampleCount = lightSettings.shadowSampleCount
        node.light?.shadowRadius = lightSettings.shadowRadius
        addChildNode(node)
    }

    func addPlaneNode(nodeName: String, assetPath: String, planeSettings: PlaneSettings?) {
        guard let node = getNodeFromScene(nodeName: nodeName, assetPath: assetPath),
                let planeSettings = planeSettings else {
            return
        }
        geometry?.firstMaterial = SCNMaterial()
        geometry?.firstMaterial?.writesToDepthBuffer = planeSettings.writesToDepthBuffer
        geometry?.firstMaterial?.colorBufferWriteMask = []
        geometry?.firstMaterial?.lightingModel = .constant

        addChildNode(node)
    }

    private func getNodeFromScene(nodeName: String, assetPath: String) -> SCNNode?  {
        guard let scene = SCNScene(named: assetPath) else {
            return nil
        }
        return scene.rootNode.childNode(withName: nodeName, recursively: true)
    }
}

