import ARKit
import SceneKit


class ARViewModel {

    func imageTrackingConfiguration() -> ARConfiguration {
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        let configuration = ARImageTrackingConfiguration()
        configuration.trackingImages = referenceImages
        configuration.maximumNumberOfTrackedImages = 2
        return configuration
    }

    func worldTrackingWithImageDetection(with planeDetection: ARWorldTrackingConfiguration.PlaneDetection? = nil) -> ARConfiguration {
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        configuration.maximumNumberOfTrackedImages = 2
        configuration.isLightEstimationEnabled = true
        if #available(iOS 12.0, *) {
            configuration.environmentTexturing = .automatic
        }
        if let planeDetection = planeDetection {
            configuration.planeDetection = planeDetection
        }
        return configuration
    }
    
    func image(correspondingTo referenceImage: ARReferenceImage) -> UIImage? {
        guard let referenceImageName = referenceImage.name,
            let correspondingImageName = assets[referenceImageName] else {
            print("no image found")
            return nil
        }
        return correspondingImageName.image()
    }

    func planeNode(with material: Any, imageSize: CGSize) -> SCNNode {
        let plane = SCNPlane(width: imageSize.width,
                             height: imageSize.height)
        plane.styleFirstMaterial(with: material)
        return SCNNode(geometry: plane)
    }

    func createSceneNodeForAsset(_ nodeName: String, arAsset: ARAsset) -> SCNNode? {
        guard let scene = SCNScene(named: arAsset.filePath()) else {
            return nil
        }
        let node = scene.rootNode.childNode(withName: nodeName, recursively: true)
        return node
    }
}
