import UIKit
import SceneKit
import ARKit

class ARView: ARSCNView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    
    }
    
    func apply(sceneSettings: SceneSettings) {
        showsStatistics = sceneSettings.showsStatistics
        autoenablesDefaultLighting = sceneSettings.autoenablesDefaultLighting
        debugOptions = sceneSettings.debugOptions.getOptionSet()
        antialiasingMode = sceneSettings.antialiasingMode.getMode()
    }
}
