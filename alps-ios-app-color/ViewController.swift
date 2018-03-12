//
//  ViewController.swift
//  ios-app-color
//
//  Created by Wen on 09.03.18.
//  Copyright © 2018 Matchmore. All rights reserved.
//

import UIKit
import AlpsSDK

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var rangeSlider: UISlider!
    @IBOutlet weak var rangeLabel: UILabel!
    @IBOutlet weak var colorPicker: UIPickerView!
    @IBOutlet weak var publishButton: UIButton!
    var pickerData : [String] = [String]()
    var currentPub : Publication!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        publishButton.layer.cornerRadius = 4
        rangeLabel.text = "20 m"
        rangeLabel.layer.masksToBounds = true
        rangeLabel.layer.cornerRadius = 8
        rangeLabel.layer.borderColor = UIColor(red: 0/255, green: 150/255, blue: 253/255, alpha: 1).cgColor
        rangeLabel.layer.borderWidth = 2.0
        rangeSlider.minimumValue = 1
        rangeSlider.setValue(20.0, animated: true)
        rangeSlider.maximumValue = 300
        self.colorPicker.delegate = self
        self.colorPicker.dataSource = self
        pickerData = ["yellow", "red", "orange", "magenta", "lightgray", "green", "cyan", "teal", "pink", "white"]
    }
    
    @IBAction func changeColor(_ sender: Any) {
        if currentPub != nil {
            // Deleting previous publication
            guard let deletePub = currentPub else {
                print("no current publication.")
                return
            }
            MatchMore.publications.delete(item: deletePub, completion: { (error) in
                print("\(String(describing: error?.message))")
            })
            createPub()
        } else {
            createPub()
        }
    }
    
    @IBAction func rangeSliderChanged(_ sender: Any) {
        self.rangeLabel.text = "\(Int(rangeSlider.value)) m"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Create a publication
    func createPub() {
        // Create New Publication
        let selectedValue = pickerData[colorPicker.selectedRow(inComponent: 0)]
        let selectedRange = rangeSlider.value
        guard let deviceId = MatchMore.mainDevice?.id else {return}
        MatchMore.createPublicationForMainDevice(publication: Publication(topic: "color", range: Double(Int(selectedRange)), duration: 100, properties: ["color": selectedValue, "id": deviceId]), completion: { result in
            switch result {
            case .success(let publication):
                print("🏔 Pub was created: 🏔\n\(publication.encodeToJSON())")
                self.currentPub = publication
            case .failure(let error):
                print("🌋 \(String(describing: error?.message)) 🌋")
            }
        })
    }
    
    // Picker data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
}

