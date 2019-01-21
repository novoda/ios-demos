import Foundation
import Vision

class RecognizeObjectsViewModel {
    private var request: VNCoreMLRequest!
    private let yolo = YOLO()
    private let semaphore = DispatchSemaphore(value: 2)
    private var currentSceneFrame: CGRect = .zero
    var onNewPrediction: ((ObjectPrediction?) -> Void)?
    var onError: (() -> Void)?

    func setCurrentFrameForModel(_ currentSceneFrame: CGRect) {
        self.currentSceneFrame = currentSceneFrame
    }

    func predictUsingVision(pixelBuffer: CVPixelBuffer) {
        semaphore.wait()
        // Vision will automatically resize the input image.
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
        try? handler.perform([request])
    }

    func setUpVision() {
        if DeveloperOptions.usingTinyYOLOModel.isActive {
            guard let visionModel = try? VNCoreMLModel(for: yolo.model.model) else {
                onError?()
                print("Error: could not create Vision model")
                return
            }
            request = VNCoreMLRequest(model: visionModel) { [weak self] request, error in
                self?.visionRequestDidComplete(request: request, error: error)
            }
        } else {
            guard #available(iOS 12.0, *) else {
                print("Error: you can't use ObjectDetector on NOT IOS12")
                onError?()
                return
            }
            guard let visionModel = try? VNCoreMLModel(for: ObjectDetector().model) else {
                onError?()
                print("Error: could not create Vision model")
                return
            }
            request = VNCoreMLRequest(model: visionModel) { [weak self] request, error in
                self?.visionRequestDidComplete(request: request, error: error)
            }
        }

        // NOTE: If you choose another crop/scale option, then you must also
        // change how the BoundingBox objects get scaled when they are drawn.
        // Currently they assume the full input image is used.
        request.imageCropAndScaleOption = .scaleFill
    }

    func visionRequestDidComplete(request: VNRequest, error: Error?) {
        self.semaphore.signal()

        if DeveloperOptions.usingTinyYOLOModel.isActive {
            onNewPrediction?(processPredictionFromTinyYolo(results: request.results))
        } else {
            onNewPrediction?(processPredictionFromVision(results: request.results))
        }
    }

    private func processPredictionFromTinyYolo(results: [Any]?) -> ObjectPrediction? {
        guard let observations = results as? [VNCoreMLFeatureValueObservation],
            let topObservation = observations.first?.featureValue.multiArrayValue else {
                print("Tiny YOLO failed finding prediction" )
                onError?()
                return nil
        }

        guard let prediction = predictionForTinyYOLO(topObservation: topObservation),
            let objectBounds = boundingBoxRectForTinyYOLO(prediction: prediction) else {
                onError?()
                print("Tiny YOLO failed finding top prediction" )
                return nil
        }
        return ObjectPrediction(name: objectNameForTinyYOLO(prediction: prediction), bounds: objectBounds)
    }

    private func processPredictionFromVision(results: [Any]?) -> ObjectPrediction? {
        guard #available(iOS 12.0, *) else {
            print("Error: you can't use ObjectDetector on NOT IOS12")
            return nil
        }
        guard let observations = results as? [VNRecognizedObjectObservation],
            let topObservation = observations.first,
            let topLabelObservation = topObservation.labels.first else {
                print("Vision failed finding prediction" )
                onError?()
                return nil
        }
        let objectRect = VNImageRectForNormalizedRect(topObservation.boundingBox,
                                                      Int(currentSceneFrame.width),
                                                      Int(currentSceneFrame.height))
        return ObjectPrediction(name: topLabelObservation.identifier, bounds: objectRect)
    }

    private func predictionForTinyYOLO(topObservation: MLMultiArray) -> YOLO.Prediction? {
        let boundingBoxes = yolo.computeBoundingBoxes(features: topObservation)
        let prominentBox = boundingBoxes.sorted{ $0.score > $1.score}
        return prominentBox.first
    }

    private func boundingBoxRectForTinyYOLO(prediction: YOLO.Prediction) -> CGRect? {
        let viewRect = CGRect(x: 0, y: 0, width: Int(currentSceneFrame.width), height: Int(currentSceneFrame.height))
        return yolo.scaleImageForCameraOutput(predictionRect: prediction.rect, viewRect: viewRect)
    }

    private func objectNameForTinyYOLO(prediction: YOLO.Prediction) -> String {
        return labels[prediction.classIndex]
    }
}
