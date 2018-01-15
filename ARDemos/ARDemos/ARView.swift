import UIKit
import SceneKit
import ARKit

class ARView: ARSCNView {
    
    private let settings: SceneSettings

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        let factory = SceneSettingsFactory()
        
        settings = SceneSettingsFactory.parseJSON()
        applySettings()
    }
    
    private func applySettings() {
        showsStatistics = settings.showsStatistics
        autoenablesDefaultLighting = settings.autoenablesDefaultLighting
        debugOptions = []
        antialiasingMode = settings.antialiasingMode
    }
}
