//
//  ViewController.swift
//  TipCalculator
//
//  Created by Derek Vitaliano Vallar on 1/6/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let VARIABLE_SEGMENT_INDEX = 3
    var tipOptions = [0.18, 0.2, 0.25, 0.3]

    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipPercentageSegment: UISegmentedControl!
    @IBOutlet weak var tipSlider: UISlider!

    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var twoTotalLabel: UILabel!
    @IBOutlet weak var threeTotalLabel: UILabel!
    @IBOutlet weak var fourTotalLabel: UILabel!
    @IBOutlet weak var variableTotalLabel: UILabel!

    @IBOutlet weak var personSliderView: UIView!

    @IBAction func onTapMainView(_ sender: Any) {
        view.endEditing(true)
    }

    @IBAction func calculateTotal(_ sender: AnyObject) {

        let bill = Double(billField.text!) ?? 0.0
        print(tipPercentageSegment.selectedSegmentIndex)
        let tip = bill * tipOptions[tipPercentageSegment.selectedSegmentIndex]
        let total = bill + tip

        tipLabel.text = String(format: "$ %.2f", tip)
        totalLabel.text = String(format: "$ %.2f", total)
        twoTotalLabel.text = String(format: "$ %.2f", total / 2)
        threeTotalLabel.text = String(format: "$ %.2f", total / 3)
        fourTotalLabel.text = String(format: "$ %.2f", total / 4)
        variableTotalLabel.text = String(format: "$ %.2f", total / 5)
    }

    @IBAction func segmentChanged(_ sender: UISegmentedControl) {

        if sender.selectedSegmentIndex == VARIABLE_SEGMENT_INDEX {
            let tip = Int(tipSlider.value)
            let tipText = String(format: "%d%%", tip)
            tipPercentageSegment.setTitle(tipText, forSegmentAt: VARIABLE_SEGMENT_INDEX)
            UIView.animate(withDuration: 0.3, animations: {
                self.tipSlider.alpha = 1.0
                self.tipSlider.isHidden = false
            })
        }
        else {
            sender.setImage(#imageLiteral(resourceName: "UpDownIcon"), forSegmentAt: VARIABLE_SEGMENT_INDEX)
            UIView.animate(withDuration: 0.3, animations: {
                self.tipSlider.alpha = 0.0
                self.tipSlider.isHidden = true
            })
        }

        calculateTotal(sender)
    }

    @IBAction func changeVariableTip(_ sender: UISlider) {

        let tip = Int(sender.value)
        let tipText = String(format: "%d%%", tip)
        tipPercentageSegment.setTitle(tipText, forSegmentAt: VARIABLE_SEGMENT_INDEX)
        tipOptions[VARIABLE_SEGMENT_INDEX] = Double(tip) * 0.01

        sender.value = Float(tip)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

