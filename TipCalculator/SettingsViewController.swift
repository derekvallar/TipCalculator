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
    let backColor = UIColor(red: 150/255.0, green: 1.0, blue: 1.0, alpha: 1.0)

    @IBOutlet weak var segmentView: UISegmentedControl!

    @IBAction func optionChanged(_ sender: UISegmentedControl) {
        let defaults = UserDefaults.standard
        defaults.set(sender.selectedSegmentIndex, forKey: defaultSegmentKey)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults = UserDefaults.standard
        segmentView.selectedSegmentIndex = defaults.integer(forKey: defaultSegmentKey)

        self.navigationController?.navigationBar.tintColor = backColor
    }
}
