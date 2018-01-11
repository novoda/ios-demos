import UIKit
import SceneKit
import ARKit

class ARView: ARSCNView {

    required init?(coder aDecoder: NSCoder) {
        <#code#>
    }

    override init(frame: CGRect) {
        // Show statistics such as fps and timing information
        showsStatistics = true

        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!

        // Set the scene to the view
        self.scene = scene
    }

    func addNodeToView() {

    }
}
