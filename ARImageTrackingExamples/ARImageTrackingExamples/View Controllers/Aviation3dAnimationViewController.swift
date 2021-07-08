import Foundation
import ARKit

class Aviation3dAnimationViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var customSwitch: BetterSegmentedControl!
    @IBOutlet weak var containerView: UIView!

    private let arViewModel = ARViewModel()
    private var airplane = SCNNode()
    private var cabin = SCNNode()
    private var imageAnchor: ARAnchor?
    private var imageNode: SCNNode?
    private let scale = 0.04
    private var animationInfo: AnimationInfo?

    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.delegate = self
        sceneView.showsStatistics = false
        sceneView.scene = SCNScene()
        prepareObjects()
        setupViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let configuration = arViewModel.worldTrackingWithImageDetection(with: .horizontal)
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        sceneView.session.pause()
    }

    private func setupViews() {
        customizeSwitch()
        sceneView.autoenablesDefaultLighting = false
        setupLightSource()
    }

    private func prepareObjects() {

        if let airplaneNodeName = ARAsset.novodaPlaneExterior.nodesOfType(.model).first?.name,
            let airplaneNode = arViewModel.createSceneNodeForAsset(airplaneNodeName, arAsset: ARAsset.novodaPlaneExterior) {
            airplane = airplaneNode
            airplane.scale = SCNVector3(scale, scale, scale)

        }

        if let cabinNodeName = ARAsset.novodaPlaneInterior.nodesOfType(.model).first?.name,
            let cabinNode = arViewModel.createSceneNodeForAsset(cabinNodeName, arAsset: ARAsset.novodaPlaneInterior) {
            cabin = cabinNode
            cabin.scale = SCNVector3(scale, scale, scale)
        }
    }

    private func customizeSwitch() {
        let novodaBlue = UIColor(red: CGFloat(78.0/255.0), green: CGFloat(162.0/255.0), blue: CGFloat(214.0/255.0), alpha: CGFloat(0.9))
        customSwitch.segments = LabelSegment.segments(withTitles: ["Interior", "Exterior"],
                                                      normalFont: UIFont(name: "HelveticaNeue", size: 13.0)!,
                                                      normalTextColor: UIColor(white: 1.0, alpha: 0.5),
                                                      selectedFont: UIFont(name: "HelveticaNeue-Bold", size: 13.0)!,
                                                      selectedTextColor: novodaBlue)
        customSwitch.setIndex(1)
        customSwitch.options = [.backgroundColor(novodaBlue),
                                .indicatorViewBackgroundColor(.white),
                                .indicatorViewInset(4.0),
                                .cornerRadius(22.0)]
        customSwitch.addTarget(self, action: #selector(controlValueChanged(_:)), for: .valueChanged)
    }

    private func setupLightSource() {
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = SCNLight.LightType.ambient
        ambientLightNode.light?.color = UIColor(white: 0.67, alpha: 1.0)
        sceneView.scene.rootNode.addChildNode(ambientLightNode)

        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        omniLightNode.light?.type = SCNLight.LightType.omni
        omniLightNode.light?.color = UIColor(white: 0.75, alpha: 1.0)
        omniLightNode.position = SCNVector3Make(0, 50, 50)
        sceneView.scene.rootNode.addChildNode(omniLightNode)
    }

    @IBAction func resetExperience() {

        DispatchQueue.main.async {
            self.animateContainerVisibility(alpha: 0)
            self.animateAirplaneTo(position: SCNVector3Make(3, 1, 0))
            self.cabin.opacity = 0.0
            self.resetState()
        }
    }

    private func resetState() {
        customSwitch.setIndex(1)
        if let imageAnchor = imageAnchor {
            sceneView.session.remove(anchor: imageAnchor)
        }
    }

    @objc private func controlValueChanged(_ sender: BetterSegmentedControl) {
        if sender.index == 0 {
            transition(fromObject: airplane, toObject: cabin)
        } else {
            transition(fromObject: cabin, toObject: airplane)
        }
    }

    private func transition(fromObject: SCNNode, toObject: SCNNode) {
        DispatchQueue.main.async {
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 3.0
            fromObject.opacity = 0.0
            toObject.opacity = 1.0
            SCNTransaction.commit()
        }
    }
}

extension Aviation3dAnimationViewController: ARSCNViewDelegate {

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }

        DispatchQueue.main.async {
            self.airplane.position = SCNVector3Make(-0.5, 0, 0)
            self.cabin.position = SCNVector3Zero
            self.cabin.opacity = 0
            node.addChildNode(self.airplane)
            node.addChildNode(self.cabin)

            self.animateAirplaneTo(position: SCNVector3Zero)
            self.animateContainerVisibility(alpha: 1)
            self.imageAnchor = imageAnchor
            self.imageNode = node
        }
    }

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {

        guard let imageNode = imageNode else {
            return
        }

        // 1. Unwrap animationInfo. Calculate animationInfo if it is nil.
        guard let animationInfo = animationInfo else {
            self.animationInfo = arViewModel.animationVariable(updateAtTime: time,
                                                          referenceImageNode: imageNode,
                                                          referenenceNode: airplane)
            return
        }

        if imageNode.hasPositionChanged(comparedTo: animationInfo) ||
            imageNode.hasOrientationChanged(comparedTo: animationInfo) {

            self.animationInfo = arViewModel.animationVariable(updateAtTime: time,
                                                               referenceImageNode: imageNode,
                                                               referenenceNode: airplane)
        }


        airplane.simdWorldPosition = arViewModel.positionRelativeTo(animationInfo: animationInfo,
                                                                    using: time)
        cabin.simdWorldPosition = arViewModel.positionRelativeTo(animationInfo: animationInfo,
                                                                 using: time)
    }

    private func animateContainerVisibility(alpha: CGFloat) {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 2
        self.containerView.alpha = alpha
        SCNTransaction.commit()
    }

    private func animateAirplaneTo(position: SCNVector3) {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 5
        self.airplane.position = position
        SCNTransaction.commit()
    }
}

