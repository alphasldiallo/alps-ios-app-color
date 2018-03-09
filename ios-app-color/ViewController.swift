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
    
    @IBOutlet weak var colorPicker: UIPickerView!
    @IBOutlet weak var publishButton: UIButton!
    let colors = ["yellow": UIColor.yellow, "red": UIColor.red, "purple": UIColor.purple, "orange": UIColor.orange, "magenta": UIColor.magenta, "lightgray": UIColor.lightGray, "green": UIColor.green, "cyan": UIColor.cyan]
    var pickerData : [String] = [String]()
    var currentPub : Publication!
    var matches = [Match]()
    var matchHandler : ExampleMatchHandler? = nil
    
    override func viewDidLoad() {
        matchHandler = ExampleMatchHandler({ matches, _ in
            // Color the background according to the match
            print("WE HAVE A MATCH")
            guard let properties = matches.last?.publication?.properties else {
                print("No properties.")
                return
            }
            let color = properties["color"] as? String
            print("COLOR IS ")
            print(color ?? "NO COLOR")
            self.view.backgroundColor = self.colors[color!]
        })
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("SUPPRESSION")
//        // Clear old subs
//        MatchMore.subscriptions.deleteAll(completion: { (error) in
//            print("\(String(describing: error?.message))")
//        })
//        // Clear old pubs
//        MatchMore.publications.deleteAll(completion: { (error) in
//            print("\(String(describing: error?.message))")
//        })
        self.colorPicker.delegate = self
        self.colorPicker.dataSource = self
    
        pickerData = ["yellow", "red", "purple", "orange", "magenta", "lightgray", "green", "cyan"]
        
        MatchMore.matchDelegates += self.matchHandler!
        
        // Polling
        MatchMore.startPollingMatches(pollingTimeInterval: 5)
        self.createPollingSubscription()
        
        // Socket (requires world_id)
        MatchMore.startListeningForNewMatches()
        self.createSocketSubscription()
        
        // Fill with cached data
        self.matches = MatchMore.allMatches
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Create a publication
    func createPub() {
        // Create New Publication
        let selectedValue = pickerData[colorPicker.selectedRow(inComponent: 0)]
        MatchMore.createPublicationForMainDevice(publication: Publication(topic: "color", range: 2000, duration: 100, properties: ["color": selectedValue]), completion: { result in
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
    
    func createSocketSubscription() {
        let subscription = Subscription(topic: "color", range: 20, duration: 100, selector: "")
        subscription.pushers = ["ws"]
        MatchMore.createSubscriptionForMainDevice(subscription: subscription, completion: { result in
            switch result {
            case .success(let sub):
                print("🏔 Socket Sub was created 🏔\n\(sub.encodeToJSON())")
            case .failure(let error):
                print("🌋 \(String(describing: error?.message)) 🌋")
            }
        })
    }
    
    func createPollingSubscription() {
        let subscription = Subscription(topic: "color", range: 20, duration: 100, selector: "")
        MatchMore.createSubscriptionForMainDevice(subscription: subscription, completion: { result in
            switch result {
            case .success(let sub):
                print("🏔 Polling Sub was created 🏔\n\(sub.encodeToJSON())")
            case .failure(let error):
                print("🌋 \(String(describing: error?.message)) 🌋")
            }
        })
    }
}

