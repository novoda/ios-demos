import UIKit
import ARKit

class ARView: ARSCNView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func apply(sceneSettings: SceneSettings) {
        showsStatistics = sceneSettings.showsStatistics
        autoenablesDefaultLighting = sceneSettings.autoenablesDefaultLighting
        debugOptions = sceneSettings.debugOptions.getOptionSet()
        antialiasingMode = sceneSettings.antialiasingMode.getMode()
    }
}
