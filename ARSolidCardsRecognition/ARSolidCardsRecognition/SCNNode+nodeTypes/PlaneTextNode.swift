import Foundation
import SceneKit
import ARKit

class PlaneTextNode: SCNPlane {

    private let label = UILabel()
    private let labelView = UIView()

    init(nodeData: PlaneNodeData) {
        super.init()
        createLabelNode(with: nodeData)
    }

    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("can't initialize from xib")
    }



    private func createLabelNode(with nodeData: PlaneNodeData) {




        let label = UILabel()
        label.text = nodeData.text
        label.textColor = .gray
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true

        labelView.frame = nodeData.frame
        labelView.addSubview(label)


        let labelMaterial = SCNMaterial()
        labelMaterial.diffuse.contents = labelView

        let plane = SCNPlane(width: nodeData.frame.width, height: nodeData.frame.height)
        firstMaterial?.diffuse.contents =  UIColor(white: 1, alpha: 0.8)
        firstMaterial?.transparency = 0.5
        materials = [labelMaterial]

    }

    private func applyConstriants() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: labelView.topAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: labelView.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: labelView.trailingAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: labelView.bottomAnchor).isActive = true
    }
    
}

struct PlaneNodeData {
    let name: String
    let text: String
    let frame: CGRect
}
