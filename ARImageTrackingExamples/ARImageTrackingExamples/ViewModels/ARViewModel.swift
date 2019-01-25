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

    func worldTrackingWithImageDetection() -> ARConfiguration {
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        configuration.maximumNumberOfTrackedImages = 2
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
}
