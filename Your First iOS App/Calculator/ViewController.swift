//
//  ViewController.swift
//  Calculator
//
//  Created by Wagner Truppel on 03/03/2016.
//  Copyright © 2016 Restless Brain. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var displayLabel: UILabel!
    private static let formatter = NSNumberFormatter()

    private var isEnteringDigits = false
    private var stack = [Double]()

    @IBAction private func digitTapped(sender: UIButton) {
        if !isEnteringDigits { displayLabel.text = "" }
        isEnteringDigits = true
        displayLabel.text! += sender.currentTitle!
    }


    @IBAction private func operationTapped(sender: UIButton) {

        if isEnteringDigits { enterTapped() }

        guard stack.count > 1 else { return }

        let last = stack.removeLast()
        let nextToLast = stack.removeLast()

        switch sender.currentTitle! {
        case "+": operate(nextToLast, last, +)
        case "−": operate(nextToLast, last, -)
        case "×": operate(nextToLast, last, *)
        case "÷":
            guard last != 0 else { return }
            operate(nextToLast, last, /)
        default: break
        }
    }

    private typealias Operation = (Double, Double) -> Double
    private func operate(leftOperand: Double, _ rightOperand: Double, _ operation: Operation) {
        let value = operation(leftOperand, rightOperand)
        displayValue = value
        stack.append(value)
        print(stack)
    }


    @IBAction private func enterTapped() {
        if let value = displayValue {
                isEnteringDigits = false
                stack.append(value)
                print(stack)
        }
    }

    private var displayValue: Double? {

        get {
            guard let
                text = displayLabel.text,
                nsnumber = ViewController.formatter.numberFromString(text)
                else { return nil }
            return nsnumber.doubleValue
        }

        set {
            if let value = newValue {
                displayLabel.text = "\(value)"
            }
        }

    }

}
