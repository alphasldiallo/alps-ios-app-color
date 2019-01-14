//
//  AppDelegate.swift
//  ios-app-color
//
//  Created by Wen on 09.03.18.
//  Copyright © 2018 Matchmore. All rights reserved.
//

import UIKit
import AlpsSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let config = MatchMoreConfig(apiKey: "YOUR-API-KEY")
        MatchMore.configure(config)
        
        MatchMore.startUsingMainDevice { result in
            guard case .success(let mainDevice) = result else { print(result.errorMessage ?? ""); return }
            print("🏔 Using device: 🏔\n\(mainDevice.encodeToJSON())")
            
            // Polling
            MatchMore.startPollingMatches(pollingTimeInterval: 5)
            
            // Socket (requires world_id)
            MatchMore.startListeningForNewMatches()
            self.createSocketSubscription()
            MatchMore.startUpdatingLocation()
            }
        return true
        }
    
    // Subscriptions
    func createSocketSubscription() {
        guard let deviceId = MatchMore.mainDevice?.id else {return}
        print(deviceId)
        let subscription = Subscription(topic: "color", range: 5, duration: 5000, selector: "id <> '\(deviceId)'")
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
}
