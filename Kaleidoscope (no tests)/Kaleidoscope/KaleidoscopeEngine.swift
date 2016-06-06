//
//  KaleidoscopeEngine.swift
//  Kaleidoscope
//
//  Created by Wagner Truppel on 24/05/2016.
//  Copyright © 2016 Restless Brain. All rights reserved.
//

import UIKit
import CoreMotion

private let TWO_PI = CGFloat(2*M_PI)


@objc
protocol KaleidoscopeEngineDelegate
{
    func kaleidoscopeEngineDidUpdateState()
}


class KaleidoscopeEngine: NSObject
{
    weak var delegate: KaleidoscopeEngineDelegate?

    var worldCenter: CGPoint!
        { didSet { resetState() } }

    var worldRadius: CGFloat!
        { didSet { resetState() } }

    struct Configuration
    {
        var numRegions = ValueInRange<Int>(minimum: 1, maximum: 20, current: 3)
        var numItemsPerRegion = ValueInRange<Int>(minimum: 1, maximum: 25, current: 10)
        var itemSize = ValueInRange<CGFloat>(minimum: 5, maximum: 25, current: 10)
        var itemElasticity = ValueInRange<CGFloat>(minimum: 0.0, maximum: 1.2, current: 1.05, step: 0.01)
        var interfaceOrientation: UIInterfaceOrientation = .Unknown
        var delegateUpdateInterval: NSTimeInterval = 1.0/60.0 // 60 updates per second
        var regionAngle: CGFloat { return TWO_PI / CGFloat(numRegions.current) }
    }
    var configuration = Configuration() {
        didSet
        {
            if configuration.numRegions.current != oldValue.numRegions.current ||
                configuration.numItemsPerRegion.current != oldValue.numItemsPerRegion.current
            { resetState() }

            if configuration.itemElasticity.current != oldValue.itemElasticity.current
            { dynamicItemBehavior?.elasticity = configuration.itemElasticity.current }
        }
    }

    private(set) var items = [Item]()

    private var dynamicAnimator = UIDynamicAnimator()
    private var dynamicItemBehavior: UIDynamicItemBehavior!
    private var gravityBehavior: UIGravityBehavior!

    private var timeOfLastDelegateUpdate: NSTimeInterval = 0
    private static let motionManager = CMMotionManager()

    func start()
    {
        startAccelerometer()
        startDynamicAnimator()
    }

    func stop()
    {
        stopDynamicAnimator()
        stopAccelerometer()
    }
    
    func regionBoundaryPath() -> UIBezierPath?
    {
        guard worldCenter != nil && worldRadius != nil else { return nil }

        let numRegions = configuration.numRegions.current
        let regionAngle = configuration.regionAngle

        if numRegions == 1
        {
            return UIBezierPath(arcCenter: worldCenter, radius: worldRadius,
                                startAngle: 0, endAngle: regionAngle, clockwise: true)
        }
        else
        {
            let path = UIBezierPath()
            path.moveToPoint(worldCenter)

            let p = CGPoint(x: worldCenter.x + worldRadius * cos(regionAngle),
                            y: worldCenter.y - worldRadius * sin(regionAngle))
            path.addLineToPoint(p)

            let startAngle = CGFloat(numRegions-1) * regionAngle
            let   endAngle = CGFloat(numRegions)   * regionAngle
            path.addArcWithCenter(worldCenter, radius: worldRadius,
                                  startAngle: startAngle, endAngle: endAngle, clockwise: true)

            path.addLineToPoint(worldCenter)
            return path
        }
    }
}


extension KaleidoscopeEngine
{
    private func resetState()
    {
        guard worldCenter != nil && worldRadius != nil else { return }

        let numRegions = configuration.numRegions.current
        assert(numRegions > 0, "invalid number of regions (\(numRegions))")

        let numItemsPerRegion = configuration.numItemsPerRegion.current
        assert(numItemsPerRegion > 0, "invalid number of items per region (\(numItemsPerRegion))")

        stopDynamicAnimator()
        createItems()
        startDynamicAnimator()
    }

    private func createItems()
    {
        guard worldCenter != nil else { fatalError("worldCenter not set") }
        guard worldRadius != nil else { fatalError("worldRadius not set") }

        let lambda: CGFloat = 0.25
        let oneMinusLambda = 1 - lambda

        let regionAngle = configuration.regionAngle
        let minTheta = lambda * regionAngle
        let maxTheta = oneMinusLambda * regionAngle
        var thetas = [CGFloat]()

        let minRadius = lambda * worldRadius
        let maxRadius = oneMinusLambda * worldRadius
        var rs = [CGFloat]()

        let numItemsPerRegion = configuration.numItemsPerRegion.current
        for _ in 0 ..< numItemsPerRegion
        {
            let theta = CGFloat.randomUniform(a: minTheta, b: maxTheta)
            thetas.append(theta)

            let r = CGFloat.randomUniform(a: minRadius, b: maxRadius)
            rs.append(r)
        }

        items = []
        let pairs = zip(rs, thetas)
        for (r, theta) in pairs
        {
            let item = Item(worldCenter: worldCenter, r: r, theta: theta)
            item.delegate = self
            items.append(item)
        }
    }

    private func startAccelerometer()
    {
        let motionManager = KaleidoscopeEngine.motionManager
        if motionManager.accelerometerAvailable
        {
            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue())
            {
                [weak self] (data, error) in
                guard error == nil else { return }
                if let myself = self, data = data
                {
                    let gravityDirection: CGVector
                    switch myself.configuration.interfaceOrientation
                    {
                    case .Portrait, .Unknown:
                        gravityDirection = CGVector(dx: +data.acceleration.x, dy: -data.acceleration.y)
                    case .PortraitUpsideDown:
                        gravityDirection = CGVector(dx: +data.acceleration.x, dy: +data.acceleration.y)
                    case .LandscapeLeft:
                        gravityDirection = CGVector(dx: -data.acceleration.y, dy: +data.acceleration.x)
                    case .LandscapeRight:
                        gravityDirection = CGVector(dx: +data.acceleration.y, dy: -data.acceleration.x)
                    }
                    myself.gravityBehavior?.gravityDirection = gravityDirection
                }
            }
        }
    }

    func stopAccelerometer()
    { KaleidoscopeEngine.motionManager.stopAccelerometerUpdates() }

    // Apparently, behaviors were not being removed with dynamicAnimator.removeAllBehaviors() in
    // stopDynamicAnimator() and it seems to be a known bug and the answer is to remove them explicitly.
    // For good measure, I'm doing it before adding new ones as well as in stopDynamicAnimator().

    private func startDynamicAnimator()
    {
        if let dynamicItemBehavior = dynamicItemBehavior { dynamicAnimator.removeBehavior(dynamicItemBehavior) }
        dynamicItemBehavior = UIDynamicItemBehavior(items: items)
        dynamicItemBehavior.elasticity = configuration.itemElasticity.current
        dynamicAnimator.addBehavior(dynamicItemBehavior)

        let collisionBehavior = UICollisionBehavior(items: items)
        if let path = regionBoundaryPath()
        { collisionBehavior.addBoundaryWithIdentifier("region boundary", forPath: path) }
        dynamicAnimator.addBehavior(collisionBehavior)

        if let gravityBehavior = gravityBehavior { dynamicAnimator.removeBehavior(gravityBehavior) }
        gravityBehavior = UIGravityBehavior(items: items)
        dynamicAnimator.addBehavior(gravityBehavior)
    }

    private func stopDynamicAnimator()
    {
        if let gravityBehavior = gravityBehavior
        { dynamicAnimator.removeBehavior(gravityBehavior) }
        gravityBehavior = nil

        if let dynamicItemBehavior = dynamicItemBehavior
        { dynamicAnimator.removeBehavior(dynamicItemBehavior) }
        dynamicItemBehavior = nil

        dynamicAnimator.removeAllBehaviors()
    }
}


extension KaleidoscopeEngine: ItemDelegate
{
    func itemSize() -> CGFloat
    { return configuration.itemSize.current }

    func itemStateDidChange()
    {
        let elapsedTime = dynamicAnimator.elapsedTime()
        let timeSinceLastDelegateUpdate = elapsedTime - timeOfLastDelegateUpdate
        if timeSinceLastDelegateUpdate >= configuration.delegateUpdateInterval
        {
            timeOfLastDelegateUpdate = elapsedTime
            delegate?.kaleidoscopeEngineDidUpdateState()
        }
    }
}


@objc
protocol ItemDelegate
{
    func itemSize() -> CGFloat
    func itemStateDidChange()
}


class Item: NSObject, UIDynamicItem
{
    weak var delegate: ItemDelegate?

    var center: CGPoint
        { didSet { delegate?.itemStateDidChange() } }

    var transform: CGAffineTransform = CGAffineTransformIdentity
        { didSet { delegate?.itemStateDidChange() } }

    // Apparently, bounds is called only once then cached and never called again,
    // so changes don't propagate to the animator. :(
    var bounds: CGRect
    { return CGRect(x: 0, y: 0, width: size, height: size) }

    var size: CGFloat
    { return (delegate != nil ? delegate!.itemSize() : 5) }

    var collisionBoundsType: UIDynamicItemCollisionBoundsType
    { return .Ellipse }

    let worldCenter: CGPoint
    let color: UIColor

    var r: CGFloat
    {
        let dx = center.x - worldCenter.x
        let dy = center.y - worldCenter.y
        return sqrt(dx * dx + dy * dy)
    }

    var theta: CGFloat
    {
        let dx = center.x - worldCenter.x
        let dy = center.y - worldCenter.y
        return (TWO_PI - atan2(dy, dx)) % TWO_PI
    }

    private init(worldCenter: CGPoint, r: CGFloat, theta: CGFloat)
    {
        self.worldCenter = worldCenter
        self.color = UIColor.randomColor()
        let x = worldCenter.x + r * cos(theta)
        let y = worldCenter.y - r * sin(theta)
        self.center = CGPoint(x: x, y: y)
        super.init()
    }
}
