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
    let darkModeKey = "DARK_MODE_KEY"
    let billFieldKey = "BILL_FIELD_KEY"
    let savedDateKey = "SAVED_DATE_KEY"

    let EMPTY_VALUE: Float = 0.0
    let VARIABLE_SEGMENT_INDEX = 3
    let animationDuration = 0.3
    var formatter = NumberFormatter()

    var firstOpen = true
    var emptyField = true
    var variableSegmentSelected = false
    var tipOptions: [Float] = [0.15, 0.2, 0.25, 0.3]
    var personCount = 2


    @IBOutlet var mainView: UIView!
    @IBOutlet weak var topInputView: UIView!
    @IBOutlet weak var allStackView: UIStackView!

    @IBOutlet var totalViewHeight: NSLayoutConstraint!
    @IBOutlet var billFieldHeight: NSLayoutConstraint!
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
        if !emptyField {
            view.endEditing(true)
        }
    }

    @IBAction func calculateTotal(_ sender: UITextField) {
        updateResults()
    }

    @IBAction func billFieldEdited(_ sender: UITextField) {

        if (sender.text?.isEmpty)! && !emptyField {

            emptyField = true
            totalViewHeight.isActive = false
            billFieldHeight.isActive = true

            UIView.animate(withDuration: animationDuration, animations: {
                self.allStackView.layoutIfNeeded()
            })
        }
        else if !(sender.text?.isEmpty)! && emptyField {

            emptyField = false
            billFieldHeight.isActive = false
            totalViewHeight.isActive = true

//            print("billFieldHeight: \(billFieldHeight.description)")
//            print("totalViewHeight: \(totalViewHeight.description)")

            UIView.animate(withDuration: animationDuration, animations: {
                self.allStackView.layoutIfNeeded()
            })
        }
    }

    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == VARIABLE_SEGMENT_INDEX {
            variableSegmentSelected = true

            let tip = (tipOptions[VARIABLE_SEGMENT_INDEX] * 100)
            let tipText = String(format: "%.0f%%", tip)

            tipPercentageSegment.setTitle(tipText, forSegmentAt: VARIABLE_SEGMENT_INDEX)

            UIView.animate(withDuration: animationDuration, animations: {
                self.tipSlider.alpha = 1.0
                self.tipSlider.isHidden = false
            })
        }
        else {
            if variableSegmentSelected {
                sender.setImage(#imageLiteral(resourceName: "UpDownIcon"), forSegmentAt: VARIABLE_SEGMENT_INDEX)
                UIView.animate(withDuration: animationDuration, animations: {
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
    }

    @IBAction func changePersons(_ sender: UISlider) {
        personCount = Int(sender.value)
        personCountLabel.text = String(personCount)
        sender.value = Float(personCount)

        updateResults()
    }

    func updateResults() {

        var bill: Float
        let input = billField.text!

        formatter.numberStyle = .decimal
        if !input.isEmpty, let value = formatter.number(from: input) {
            bill = value.floatValue
        }
        else {
            bill = EMPTY_VALUE
        }

        let tipPercentage = tipOptions[tipPercentageSegment.selectedSegmentIndex]
        let billValue = bill
        let tipTotal = billValue * tipPercentage
        let total = billValue + tipTotal

        formatter.numberStyle = .currency
        tipLabel.text = formatter.string(from: NSNumber(value: tipTotal))
        totalLabel.text = formatter.string(from: NSNumber(value: total))

        tipPerPersonLabel.text = formatter.string(from: NSNumber(value: tipTotal / Float(personCount)))
        variableTotalPerPersonLabel.text = formatter.string(from: NSNumber(value: total / Float(personCount)))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load")

        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)

        if mainFrameHeight == nil {
            mainFrameHeight = UIScreen.main.bounds.height - (self.navigationController?.navigationBar.frame.height)!
        }

        billField.becomeFirstResponder()
        billField.placeholder = formatter.currencySymbol

        let defaults = UserDefaults.standard
        tipOptions[VARIABLE_SEGMENT_INDEX] = defaults.float(forKey: tipValueKey)
        tipSlider.value = tipOptions[VARIABLE_SEGMENT_INDEX] * 100


        tipPercentageSegment.selectedSegmentIndex = defaults.integer(forKey: defaultSegmentKey)
        tipPercentageSegment.sendActions(for: .valueChanged)

        if let savedDate = defaults.object(forKey: savedDateKey) {
            if (savedDate as! Date).timeIntervalSinceNow * -1 < 600.0 {
                if let savedBill = defaults.object(forKey: billFieldKey) as! String? {
                    if !savedBill.isEmpty {
                        billField.text = savedBill
                        emptyField = false
                        updateResults()
                    }
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("view will appear")

        let defaults = UserDefaults.standard
        if defaults.bool(forKey: darkModeKey) {
            navigationController?.navigationBar.barTintColor = UIColor(red: 0.0, green: 89/255.0, blue: 139/255.0, alpha: 1.0)
            topInputView.backgroundColor = UIColor(red: 0.0, green: 89/255.0, blue: 139/255.0, alpha: 1.0)
            mainView.backgroundColor = UIColor(red: 0.0, green: 71/255.0, blue: 94/255.0, alpha: 1.0)
        }
        else {
            navigationController?.navigationBar.barTintColor = UIColor(red: 0.0, green: 190/255.0, blue: 1.0, alpha: 1.0)
            topInputView.backgroundColor = UIColor(red: 0.0, green: 190/255.0, blue: 1.0, alpha: 1.0)
            mainView.backgroundColor = UIColor(red: 0.0, green: 135/255.0, blue: 188/255.0, alpha: 1.0)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("view did appear")

//        print("billFieldHeight: \(billFieldHeight.description)")
//        print("totalViewHeight: \(totalViewHeight.description)")

        // totalViewHeight may deactivate after a proc of keyboardWillShow. Can't find the problem, this is a (bad) solution (wont work in keyboardWillShow).
        if firstOpen{
            firstOpen = false

            if !emptyField {
                print("Found text, activating constraints")
                if billFieldHeight.isActive {
                    billFieldHeight.isActive = false
                }
                if !totalViewHeight.isActive {
                    totalViewHeight.isActive = true
                }
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("view will disappear")

        let defaults = UserDefaults.standard
        let date = Date.init()

        defaults.set(date, forKey: savedDateKey)
        defaults.set(billField.text, forKey: billFieldKey)
        defaults.synchronize()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("view did disappear")
    }

    // Can proc multiple times on startup if on real device. Ask about easier way to detect last proc, if multiple.
    func keyboardWillShow(_ notification: Notification) {
        print("KeyboardWillShow")

        if let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardRect.height
        }

        billFieldHeight.constant = mainFrameHeight! - keyboardHeight!
        totalViewHeight.constant = keyboardHeight! * 5 / 3

        self.allStackView.layoutIfNeeded()

//        print("billFieldHeight: \(billFieldHeight.description)")
//        print("totalViewHeight: \(totalViewHeight.description)")
    }

    func keyboardWillHide(_ notification: Notification) {
        print("KeyboardWillHide")

        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
}

