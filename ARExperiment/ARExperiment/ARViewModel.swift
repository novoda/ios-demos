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

    func getCenterOfObject(objectRect: CGRect) -> CGPoint {

        let width = objectRect.width
        let height = objectRect.height

        let x = (width/2) + objectRect.origin.x
        let y = (height/2) + objectRect.origin.y


        return CGPoint(x: x, y: y)
    }
}
