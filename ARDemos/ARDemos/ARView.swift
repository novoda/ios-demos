import UIKit
import SceneKit
import ARKit

class ARView: ARSCNView {
    
    private var sceneSettings: SceneSettings?
    private let settingsFactory = SceneSettingsFactory()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        sceneSettings = settingsFactory.parseJSON()
        applySettings()
    }
    
    private func applySettings() {
        guard let settings = sceneSettings else { return }
        showsStatistics = settings.showsStatistics
        autoenablesDefaultLighting = settings.autoenablesDefaultLighting
        debugOptions = settings.debugOptions.getOptionSet()
        antialiasingMode = settings.antialiasingMode.getMode()
    }
}
