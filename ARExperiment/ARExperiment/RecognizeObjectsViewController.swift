//
//  RecognizeObjectsViewController.swift
//  ARExperiment
//
//  Created by Berta Devant on 09/01/2018.
//  Copyright © 2018 Berta Devant. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class RecognizeObjectsViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    fileprivate let dispatchQueueML = DispatchQueue(label: "com.hw.dispatchqueueml") // A Serial Queue
    fileprivate let yolo = YOLO()
    fileprivate var boundingBox = BoundingBox()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func loopCoreMLUpdate() {
        dispatchQueueML.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.getCoreMLPredictions()
            strongSelf.loopCoreMLUpdate()
        }
    }

    private func getCoreMLPredictions() {
        guard let pixelBufferCamerCapture : CVPixelBuffer = (sceneView.session.currentFrame?.capturedImage) else {
            return
        }
        if let predictions = try? yolo.predict(image: pixelBufferCamerCapture) {
            if let boundingBox = predictions.first {
                showOnMainThread(boundingBox)
            }
        }
    }

    func showOnMainThread(_ boundingBox: YOLO.Prediction) {
        DispatchQueue.main.async {
            self.show(prediction: boundingBox)
        }
    }

    func show(prediction: YOLO.Prediction) {
        boundingBox.show(frame: prediction.rect, label: "", color: .blue)
    }

}
