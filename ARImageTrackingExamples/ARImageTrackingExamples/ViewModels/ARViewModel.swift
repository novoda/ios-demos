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

    func animationVariable(updateAtTime time: TimeInterval,
                           referenceImageNode: SCNNode,
                           referenenceNode: SCNNode) -> AnimationInfo {
        return refreshAnimationVariables(startTime: time,
                                         initialPosition: referenenceNode.simdWorldPosition,
                                         finalPosition: referenceImageNode.simdWorldPosition,
                                         initialOrientation: referenenceNode.simdWorldOrientation,
                                         finalOrientation: referenceImageNode.simdWorldOrientation)
    }

    func positionRelativeTo(animationInfo: AnimationInfo, using time: TimeInterval) -> simd_float3 {
        // 3. Calculate interpolation based on passedTime/totalTime ratio.
        let passedTime = time - animationInfo.startTime
        let minTime = min(Float(passedTime/animationInfo.duration), 1)
        // Calculate "ease out" timing by curving function to time parameter
        let easeOutTime = sin(minTime * .pi * 0.5)

        // 4. Calculate and set new model position and orientation.
        let positionForEaseOutTime = simd_make_float3(easeOutTime, easeOutTime, easeOutTime)
        return simd_mix(animationInfo.initialModelPosition,
                        animationInfo.finalModelPosition,
                        positionForEaseOutTime)
    }

    func orientationRelativeTo(animationInfo: AnimationInfo, using time: TimeInterval) -> simd_quatf {
        // 3. Calculate interpolation based on passedTime/totalTime ratio.
        let passedTime = time - animationInfo.startTime
        let minTime = min(Float(passedTime/animationInfo.duration), 1)
        // Calculate "ease out" timing by curving function to time parameter
        let easeOutTime = sin(minTime * .pi * 0.5)
        return simd_slerp(animationInfo.initialModelRotation, animationInfo.finalModelRotation, easeOutTime)
    }

    private func refreshAnimationVariables(startTime: TimeInterval,
                                   initialPosition: float3,
                                   finalPosition: float3,
                                   initialOrientation: simd_quatf,
                                   finalOrientation: simd_quatf) -> AnimationInfo {
        let distance = simd_distance(initialPosition, finalPosition)
        // Average speed of movement is 0.15 m/s.
        let speed = Float(0.15)
        // Total time is calculated as distance/speed. Min time is set to 0.1s and max is set to 2s.
        let animationDuration = Double(min(max(0.1, distance/speed), 2))
        return AnimationInfo(startTime: startTime,
                             duration: animationDuration,
                             initialModelPosition: initialPosition,
                             initialModelRotation: initialOrientation,
                             finalModelPosition: finalPosition,
                             finalModelRotation: finalOrientation)
    }
}
