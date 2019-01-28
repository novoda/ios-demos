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

    func image(correspondingTo referenceImage: ARReferenceImage, for imageOrientation: ImageOrientation) -> UIImage? {
        guard let referenceImageName = referenceImage.name,
            let correspondingImageName = correspondingImageName(to: referenceImageName, for: imageOrientation) else {
            print("no image found")
            return nil
        }
        return correspondingImageName.image()
    }

    func planeNode(with material: Any?, imageSize: CGSize, colorBufferWriteMask: SCNColorMask? = nil) -> SCNNode {
        let plane = SCNPlane(width: imageSize.width,
                             height: imageSize.height)
        if let material = material {
            plane.styleFirstMaterial(with: material)
        }
        if let colorBuffer = colorBufferWriteMask {
            plane.firstMaterial?.colorBufferWriteMask = colorBuffer
        }
        return SCNNode(geometry: plane)
   }
    
    private func correspondingImageName(to referenceImageName: String,
                                        for imageOrientation: ImageOrientation) -> String? {
        return "\(referenceImageName)\(imageOrientation.text)"
    }
}
