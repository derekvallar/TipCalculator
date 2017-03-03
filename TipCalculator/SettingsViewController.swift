//
//  SettingsViewController.swift
//  TipCalculator
//
//  Created by Derek Vitaliano Vallar on 1/8/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    let defaultSegmentKey = "DEFAULT_SEGMENT_KEY"
    let darkModeKey = "DARK_MODE_KEY"

    let backColor = UIColor(red: 150/255.0, green: 1.0, blue: 1.0, alpha: 1.0)

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var settingsView: UIView!

    @IBOutlet weak var segmentView: UISegmentedControl!
    @IBOutlet weak var switchControl: UISwitch!

    @IBAction func optionChanged(_ sender: UISegmentedControl) {
        let defaults = UserDefaults.standard
        defaults.set(sender.selectedSegmentIndex, forKey: defaultSegmentKey)
    }

    @IBAction func darkModeChanged(_ sender: UISwitch) {
        let defaults = UserDefaults.standard
        defaults.set(sender.isOn, forKey: darkModeKey)
        changeColorMode(sender.isOn)
    }

    func changeColorMode(_ darkMode: Bool) {
        if darkMode {
            navigationController?.navigationBar.barTintColor = UIColor(red: 0.0, green: 89/255.0, blue: 139/255.0, alpha: 1.0)
            settingsView.backgroundColor = UIColor(red: 0.0, green: 89/255.0, blue: 139/255.0, alpha: 1.0)

            mainView.backgroundColor = UIColor(red: 0.0, green: 71/255.0, blue: 94/255.0, alpha: 1.0)

        }
        else {
            navigationController?.navigationBar.barTintColor = UIColor(red: 0.0, green: 190/255.0, blue: 1.0, alpha: 1.0)
            settingsView.backgroundColor = UIColor(red: 0.0, green: 190/255.0, blue: 1.0, alpha: 1.0)

            mainView.backgroundColor = UIColor(red: 0.0, green: 135/255.0, blue: 188/255.0, alpha: 1.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults = UserDefaults.standard
        segmentView.selectedSegmentIndex = defaults.integer(forKey: defaultSegmentKey)
        switchControl.isOn = defaults.bool(forKey: darkModeKey)

        self.navigationController?.navigationBar.tintColor = backColor

        changeColorMode(defaults.bool(forKey: darkModeKey))
    }
}
