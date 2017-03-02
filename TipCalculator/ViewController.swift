//
//  ViewController.swift
//  TipCalculator
//
//  Created by Derek Vitaliano Vallar on 1/6/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let tipValueKey = "TIP_VALUE_KEY"
    let defaultSegmentKey = "DEFAULT_SEGMENT_KEY"

    let EMPTY_VALUE: Float = 0.0
    let VARIABLE_SEGMENT_INDEX = 3

    var firstOpen = true
    var variableSegmentSelected = false
    var tipOptions: [Float] = [0.15, 0.2, 0.25, 0.3]
    var personCount = 2

    var bill: Float {
        get {
            let input = billField.text!

            if !input.isEmpty {
                if let value = Float(input) {
                    return value
                }
            }
            return EMPTY_VALUE
        }
    }

    @IBOutlet weak var allStackView: UIStackView!
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var totalViewHeight: NSLayoutConstraint!
    @IBOutlet weak var billFieldHeight: NSLayoutConstraint!
    var keyboardHeight: CGFloat?
    var mainFrameHeight: CGFloat?

    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipPercentageSegment: UISegmentedControl!
    @IBOutlet weak var tipSlider: UISlider!

    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!

    @IBOutlet weak var personCountLabel: UILabel!
    @IBOutlet weak var personSlider: UISlider!
    @IBOutlet weak var tipPerPersonLabel: UILabel!
    @IBOutlet weak var variableTotalPerPersonLabel: UILabel!


    @IBAction func onTapMainView(_ sender: Any) {
        view.endEditing(true)
    }

    @IBAction func calculateTotal(_ sender: UITextField) {
        updateResults()
    }

    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == VARIABLE_SEGMENT_INDEX {
            variableSegmentSelected = true
            let tip = Int(tipOptions[VARIABLE_SEGMENT_INDEX] * 100)
            let tipText = String(format: "%d%%", tip)
            tipPercentageSegment.setTitle(tipText, forSegmentAt: VARIABLE_SEGMENT_INDEX)

            UIView.animate(withDuration: 0.3, animations: {
                self.tipSlider.alpha = 1.0
                self.tipSlider.isHidden = false
            })

        }
        else {
            if variableSegmentSelected {
                sender.setImage(#imageLiteral(resourceName: "UpDownIcon"), forSegmentAt: VARIABLE_SEGMENT_INDEX)
                UIView.animate(withDuration: 0.3, animations: {
                    self.tipSlider.alpha = 0.0
                    self.tipSlider.isHidden = true
                })

                variableSegmentSelected = false
            }
        }

        updateResults()
    }


    @IBAction func changeVariableTip(_ sender: UISlider) {
        let tip = Int(sender.value)
        let tipText = String(format: "%d%%", tip)
        tipPercentageSegment.setTitle(tipText, forSegmentAt: VARIABLE_SEGMENT_INDEX)
        tipOptions[VARIABLE_SEGMENT_INDEX] = Float(tip) * 0.01
        sender.value = Float(tip)

        updateResults()
    }

    @IBAction func finishedPickingTip(_ sender: UISlider) {
        let defaults = UserDefaults.standard
        defaults.set(sender.value * 0.01, forKey: tipValueKey)
        defaults.synchronize()
    }

    @IBAction func changePersons(_ sender: UISlider) {
        personCount = Int(sender.value)
        personCountLabel.text = String(personCount)
        sender.value = Float(personCount)

        updateResults()
    }

    func updateResults() {
        let tipPercentage = tipOptions[tipPercentageSegment.selectedSegmentIndex]
        let tipTotal = bill * tipPercentage
        let total = bill + tipTotal

        tipLabel.text = String(format: "$ %.2f", tipTotal)
        totalLabel.text = String(format: "$ %.2f", total)

        tipPerPersonLabel.text = String(format: "$ %.2f", tipTotal / Float(personCount))
        variableTotalPerPersonLabel.text = String(format: "$ %.2f", total / Float(personCount))
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)

        if mainFrameHeight == nil {
            mainFrameHeight = UIScreen.main.bounds.height - (self.navigationController?.navigationBar.frame.height)!
        }

        billField.becomeFirstResponder()

        let defaults = UserDefaults.standard
        tipOptions[VARIABLE_SEGMENT_INDEX] = defaults.float(forKey: tipValueKey)
        tipSlider.value = tipOptions[VARIABLE_SEGMENT_INDEX]
        tipPercentageSegment.selectedSegmentIndex = defaults.integer(forKey: defaultSegmentKey)
        tipPercentageSegment.sendActions(for: .valueChanged)
    }

    func keyboardWillShow(_ notification: Notification) {
        if firstOpen {
            if let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                keyboardHeight = keyboardRect.height
            }

            if !keyboardHeight!.isZero {
                billFieldHeight.constant = mainFrameHeight! - keyboardHeight!
                self.allStackView.layoutIfNeeded()
            }
        }
    }

    func keyboardWillHide(_ notification: Notification) {
        if firstOpen {
            firstOpen = false

            totalView.isHidden = false
            billFieldHeight.isActive = false
            totalViewHeight.isActive = true

            totalViewHeight.constant = keyboardHeight! * 5 / 3
            UIView.animate(withDuration: 1.0, animations: {
                self.allStackView.layoutIfNeeded()
            })
        }
    }
}

