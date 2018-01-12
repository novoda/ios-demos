import UIKit
import SceneKit
import ARKit

class ARView: ARSCNView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        // Show statistics such as fps and timing information
        showsStatistics = true
        debugOptions = []
        antialiasingMode = .multisampling4X

        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!

        // Set the scene to the view
        self.scene = scene
    }
    
    private func setupView() {
        showsStatistics = false
        debugOptions = []
        antialiasingMode = .multisampling4X
    }
    
    func addNodeToView() {

    }
}
