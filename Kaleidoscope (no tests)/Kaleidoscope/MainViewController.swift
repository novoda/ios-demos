//
//  MainViewController.swift
//  Kaleidoscope
//
//  Created by Wagner Truppel on 24/05/2016.
//  Copyright © 2016 Restless Brain. All rights reserved.
//

import UIKit


class MainViewController: UIViewController
{
    @IBOutlet private weak var kaleidoscopeView: KaleidoscopeView!

    private var controlsViewController: ControlsViewController! {
        didSet { controlsViewController?.delegate = self }
    }

    private var kaleidoscopeEngine: KaleidoscopeEngine! {
        didSet { kaleidoscopeEngine?.delegate = self }
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        initialiseKaleidoscopeEngine()
    }

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        initialiseViews()
    }

    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        updateKaleidoscopeEngineGeometry()
        kaleidoscopeEngine?.start()
    }

    override func viewWillDisappear(animated: Bool)
    {
        kaleidoscopeEngine?.stop()
        super.viewWillDisappear(animated)
    }

    override func viewWillTransitionToSize(size: CGSize,
                                           withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator)
    {
        coordinator.animateAlongsideTransition({_ in})
        {
            [weak self] _ in
            if let myself = self { myself.updateKaleidoscopeEngineGeometry() }
        }
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }

}


extension MainViewController: SegueIdentifierAware
{
    enum SegueIdentifier: String
    {
        case EmbedControls
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        let segueID = segueIdentifierForSegue(segue)
        switch segueID
        {
        case .EmbedControls:
            if let controlsViewController = segue.destinationViewController as? ControlsViewController
            { self.controlsViewController = controlsViewController }
            else { fatalError("invalid destination view controller for segue identifier '\(segueID)'") }
        }
    }
}


extension MainViewController: ControlsViewControllerDelegate
{
    func showAllRegionsDidChangeTo(showAllRegions: Bool)
    { kaleidoscopeView?.showAllRegions = showAllRegions }

    func showRefRegionDidChangeTo(showRefRegion: Bool)
    { kaleidoscopeView?.showRefRegion = showRefRegion }

    func numRegionsDidChangeTo(numRegions: Int)
    {
        kaleidoscopeEngine?.configuration.numRegions.current = numRegions
        updateKaleidoscopeViewForChangeInNumRegions()
    }

    func numItemsPerRegionsDidChangeTo(numItemsPerRegion: Int)
    { kaleidoscopeEngine?.configuration.numItemsPerRegion.current = numItemsPerRegion }

    func itemSizeDidChangeTo(itemSize: CGFloat)
    { kaleidoscopeEngine?.configuration.itemSize.current = itemSize }

    func itemElasticityDidChangeTo(itemElasticity: CGFloat)
    { kaleidoscopeEngine?.configuration.itemElasticity.current = itemElasticity }
}


extension MainViewController: KaleidoscopeEngineDelegate
{
    func kaleidoscopeEngineDidUpdateState()
    { kaleidoscopeView?.items = kaleidoscopeEngine!.items }
}


extension MainViewController
{
    private func initialiseKaleidoscopeEngine()
    {
        kaleidoscopeEngine = KaleidoscopeEngine()

        // Configure initial engine values here, if different from default values.
    }

    private func initialiseViews()
    {
        guard kaleidoscopeEngine != nil else { fatalError("MainViewController: kaleidoscopeEngine not set") }
        guard kaleidoscopeView != nil else { fatalError("MainViewController: kaleidoscopeView not set") }
        guard controlsViewController != nil else { fatalError("MainViewController: controlsViewController not set") }

        kaleidoscopeView.showAllRegions = true
        kaleidoscopeView.showRefRegion = false
        updateKaleidoscopeViewForChangeInNumRegions()

        let engineConfiguration = kaleidoscopeEngine.configuration
        let controlsViewModel = ControlsViewController.ViewModel(
            showAllRegions: kaleidoscopeView.showAllRegions,
            showRefRegion: kaleidoscopeView.showRefRegion,
            numRegions: engineConfiguration.numRegions,
            numItemsPerRegion: engineConfiguration.numItemsPerRegion,
            itemSize: engineConfiguration.itemSize,
            itemElasticity: engineConfiguration.itemElasticity
        )
        controlsViewController.viewModel = controlsViewModel
    }

    private func updateKaleidoscopeEngineGeometry()
    {
        guard kaleidoscopeEngine != nil else { fatalError("MainViewController: kaleidoscopeEngine not set") }

        let viewCenter = kaleidoscopeView.viewCenter
        kaleidoscopeEngine.worldCenter = viewCenter

        let viewRadius = kaleidoscopeView.viewRadius
        kaleidoscopeEngine.worldRadius = viewRadius

        let interfaceOrientation = UIApplication.sharedApplication().statusBarOrientation
        kaleidoscopeEngine.configuration.interfaceOrientation = interfaceOrientation

        kaleidoscopeView.regionBoundaryPath = kaleidoscopeEngine.regionBoundaryPath()
    }

    private func updateKaleidoscopeViewForChangeInNumRegions()
    {
        let engineConfiguration = kaleidoscopeEngine.configuration
        kaleidoscopeView.numRegions = engineConfiguration.numRegions.current
        kaleidoscopeView.regionAngle = engineConfiguration.regionAngle

        kaleidoscopeView.regionBoundaryPath = kaleidoscopeEngine.regionBoundaryPath()
    }
}
