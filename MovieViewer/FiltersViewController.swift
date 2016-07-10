//
//  FiltersViewController.swift
//  MovieViewer
//
//  Created by hvmark on 7/10/16.
//  Copyright © 2016 Dang Quoc Huy. All rights reserved.
//

import UIKit

protocol FiltersViewControllerDelegate {
    func updateSettings(vc: FiltersViewController, settings: [String: String])
    func inject(vc: FiltersViewController)
}

class FiltersViewController: UITableViewController {
    
    var delegate: FiltersViewControllerDelegate?

    @IBOutlet weak var releaseYearPicker: UIPickerView!
    @IBOutlet weak var primaryReleaseYearPicker: UIPickerView!
    
    var settings: [String: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        releaseYearPicker.dataSource = self
        releaseYearPicker.delegate = self
        primaryReleaseYearPicker.dataSource = self
        primaryReleaseYearPicker.delegate = self
    }
    
    @IBAction func onAdultSwitch(sender: AnyObject) {
        let adultSwitch = sender as! UISwitch
        
        if adultSwitch.on {
            settings["certification_country"] = "US"
            settings["certification"] = "R"
        } else {
            settings.removeValueForKey("certification_country")
            settings.removeValueForKey("certification")
        }
    }
    
    func injected() {
        guard delegate != nil else { return }
        delegate?.inject(self)
    }
    
    override func viewWillDisappear(animated: Bool) {
        print ("dimissing filters view controller")
        updateSettings()
    }
    
    func updateSettings() {
        guard delegate != nil else { return }
        delegate?.updateSettings(self, settings: settings)
    }
}


extension FiltersViewController: UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
}

extension FiltersViewController: UIPickerViewDelegate {
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row + 2007);
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var settingString: String = ""
        
        if pickerView == releaseYearPicker {
            print ("release year picker")
            settingString = "release_year"
        }
        
        if pickerView == primaryReleaseYearPicker {
            print ("primary release year picker")
            settingString = "primary_release_year"
        }
        
        settings[settingString] = String(row + 2007)
    }
}