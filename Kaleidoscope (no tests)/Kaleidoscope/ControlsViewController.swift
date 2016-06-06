//
//  ControlsViewController.swift
//  Kaleidoscope
//
//  Created by Wagner Truppel on 24/05/2016.
//  Copyright © 2016 Restless Brain. All rights reserved.
//

import UIKit


class SteppableSlider: UISlider
{
    var step: Float = 0
}


@objc
protocol ControlsViewControllerDelegate
{
    func showAllRegionsDidChangeTo(showAllRegions: Bool)
    func showRefRegionDidChangeTo(showRefRegion: Bool)
    func numRegionsDidChangeTo(numRegions: Int)
    func numItemsPerRegionsDidChangeTo(numItemsPerRegion: Int)
    func itemSizeDidChangeTo(itemSize: CGFloat)
    func itemElasticityDidChangeTo(itemElasticity: CGFloat)
}


class ControlsViewController: UITableViewController
{
    @IBOutlet private weak var numRegionsLabel:          UILabel!
    @IBOutlet private weak var numItemsPerRegionLabel:   UILabel!
    @IBOutlet private weak var itemSizeLabel:            UILabel!
    @IBOutlet private weak var itemElasticityLabel:      UILabel!
    @IBOutlet private weak var numRegionsStepper:        UIStepper!
    @IBOutlet private weak var numItemsPerRegionStepper: UIStepper!
    @IBOutlet private weak var itemSizeSlider:           UISlider!
    @IBOutlet private weak var itemElasticitySlider:     SteppableSlider!
    @IBOutlet private weak var showAllRegionsSwitch:     UISwitch!
    @IBOutlet private weak var showRefRegionSwitch:      UISwitch!

    weak var delegate: ControlsViewControllerDelegate?

    var viewModel: ViewModel!
    struct ViewModel
    {
        let showAllRegions:    Bool
        let showRefRegion:     Bool
        let numRegions:        ValueInRange<Int>
        let numItemsPerRegion: ValueInRange<Int>
        let itemSize:          ValueInRange<CGFloat>
        let itemElasticity:    ValueInRange<CGFloat>

        static var itemElasticityNumberFormatter: NSNumberFormatter
        {
            let formatter = NSNumberFormatter()
            formatter.minimumIntegerDigits = 1
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
            return formatter
        }
    }

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        updateUI()
    }
}


extension ControlsViewController
{
    private func updateUI()
    {
        guard viewModel != nil else { fatalError("ControlsViewController: view model not set") }

        let showAllRegions = viewModel.showAllRegions
        showAllRegionsSwitch.on = showAllRegions

        let showRefRegion = viewModel.showRefRegion
        showRefRegionSwitch.on = showRefRegion

        let numRegions = viewModel.numRegions
        numRegionsLabel.text = "\(numRegions.current)"
        numRegionsStepper.minimumValue = Double(numRegions.minimum)
        numRegionsStepper.maximumValue = Double(numRegions.maximum)
        numRegionsStepper.value = Double(numRegions.current)

        let numItemsPerRegion = viewModel.numItemsPerRegion
        numItemsPerRegionLabel.text = "\(numItemsPerRegion.current)"
        numItemsPerRegionStepper.minimumValue = Double(numItemsPerRegion.minimum)
        numItemsPerRegionStepper.maximumValue = Double(numItemsPerRegion.maximum)
        numItemsPerRegionStepper.value = Double(numItemsPerRegion.current)

        let itemSize = viewModel.itemSize
        itemSizeLabel.text = "\(Int(itemSize.current))"
        itemSizeSlider.minimumValue = Float(itemSize.minimum)
        itemSizeSlider.maximumValue = Float(itemSize.maximum)
        itemSizeSlider.value = Float(itemSize.current)

        let itemElasticity = viewModel.itemElasticity
        itemElasticityLabel.text = ViewModel.itemElasticityNumberFormatter.stringFromNumber(itemElasticity.current)
        if let step = viewModel.itemElasticity.step { itemElasticitySlider.step = Float(step) }
        itemElasticitySlider.minimumValue = Float(itemElasticity.minimum)
        itemElasticitySlider.maximumValue = Float(itemElasticity.maximum)
        itemElasticitySlider.value = Float(itemElasticity.current)
    }

    @IBAction private func stepperValueChanged(sender: UIStepper)
    {
        switch sender
        {
        case numRegionsStepper:
            let numRegions = Int(numRegionsStepper.value)
            numRegionsLabel.text = "\(numRegions)"
            delegate?.numRegionsDidChangeTo(numRegions)
        case numItemsPerRegionStepper:
            let numItemsPerRegion = Int(numItemsPerRegionStepper.value)
            numItemsPerRegionLabel.text = "\(numItemsPerRegion)"
            delegate?.numItemsPerRegionsDidChangeTo(numItemsPerRegion)
        default:
            fatalError("Unhandled sender in call to stepperValueChanged(:)")
            break
        }
    }

    @IBAction private func sliderValueChanged(sender: UISlider)
    {
        switch sender
        {
        case itemSizeSlider:
            let itemSize = CGFloat(itemSizeSlider.value)
            itemSizeLabel.text = "\(Int(itemSize))"
            delegate?.itemSizeDidChangeTo(itemSize)
        case itemElasticitySlider:
            let itemElasticity: CGFloat
            let step = itemElasticitySlider.step
            if step > 0 { itemElasticity = CGFloat(step * Float(Int(itemElasticitySlider.value / step))) }
            else { itemElasticity = CGFloat(itemElasticitySlider.value) }
            itemElasticityLabel.text = ViewModel.itemElasticityNumberFormatter.stringFromNumber(itemElasticity)
            delegate?.itemElasticityDidChangeTo(itemElasticity)
        default:
            fatalError("Unhandled sender in call to sliderValueChanged(:)")
            break
        }
    }

    @IBAction private func switchValueChanged(sender: UISwitch)
    {
        switch sender
        {
        case showAllRegionsSwitch:
            let showAllRegions = showAllRegionsSwitch.on
            delegate?.showAllRegionsDidChangeTo(showAllRegions)
        case showRefRegionSwitch:
            let showRefRegion = showRefRegionSwitch.on
            delegate?.showRefRegionDidChangeTo(showRefRegion)
        default:
            fatalError("Unhandled sender in call to switchValueChanged(:)")
            break
        }
    }
}
