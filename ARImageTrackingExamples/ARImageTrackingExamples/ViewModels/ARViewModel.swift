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
    
    func cardNode(for size: CGSize, withImage image: UIImage) -> SCNNode {
        let cardSize = CGSize(width: size.width * .half,
                              height: size.height)
        let solidDataPlaneNode = planeNode(with: image, imageSize: cardSize)
        solidDataPlaneNode.opacity = 0
        solidDataPlaneNode.position.z -= 0.01
        solidDataPlaneNode.animate(xOffset: -size.width * .third)
        return solidDataPlaneNode
    }
}
