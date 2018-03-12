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
    var exampleMatchHandler: ExampleMatchHandler!
    
    let colors = ["yellow": UIColor.yellow,
                  "red": UIColor(red: 255/255, green: 106/255, blue: 93/255, alpha: 1),
                  "orange": UIColor.orange,
                  "magenta": UIColor(red: 255/255, green: 116/255, blue: 217/255, alpha: 1),
                  "lightgray": UIColor.lightGray,
                  "green": UIColor(red: 134/255, green: 255/255, blue: 150/255, alpha: 1),
                  "cyan": UIColor.cyan,
                  "teal": UIColor(red: 20/255, green: 229/255, blue: 204/255, alpha: 1),
                  "pink": UIColor(red: 255/255, green: 173/255, blue: 171/255, alpha: 1),
                  "white": UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                  ]
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let config = MatchMoreConfig(apiKey: "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiJ9.eyJpc3MiOiJhbHBzIiwic3ViIjoiZjhhYjRmNjItZjlkMS00YWQxLWJjMjUtMzIyNWMzY2M5NmZjIiwiYXVkIjpbIlB1YmxpYyJdLCJuYmYiOjE1MjA4NTg4MTEsImlhdCI6MTUyMDg1ODgxMSwianRpIjoiMSJ9.yFz-nP8jHde8d6Y_YtOdfSe2_tWqlr1sNzbMhw583Sxf3w8yqNnU3PgpQv9z0_FsdM1Q-pdsrK38YEkZR5Ceeg")
        MatchMore.configure(config)
        
        MatchMore.startUsingMainDevice { result in
            guard case .success(let mainDevice) = result else { print(result.errorMessage ?? ""); return }
            print("🏔 Using device: 🏔\n\(mainDevice.encodeToJSON())")

            // Start Monitoring Matches
            self.exampleMatchHandler = ExampleMatchHandler { matches, _ in
                print("🏔 You've got new matches!!! 🏔\n\(matches.map { $0.publication?.encodeToJSON() })")
                // Color the background according to the match
                let mostRecentDate = matches.max(by: {
                    $0.createdAt! < $1.createdAt!
                })
                guard let properties = mostRecentDate?.publication?.properties else {
                    print("No properties.")
                    return
                }
                let color = properties["color"] as? String
                self.window?.rootViewController?.view.backgroundColor = self.colors[color!]
            }
            MatchMore.matchDelegates += self.exampleMatchHandler
            
            // Polling
            MatchMore.startPollingMatches(pollingTimeInterval: 5)
            self.createPollingSubscription()
            
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
        let subscription = Subscription(topic: "color", range: 20, duration: 100, selector: "id <> '\(deviceId)'")
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
        guard let deviceId = MatchMore.mainDevice?.id else {return}
        let subscription = Subscription(topic: "color", range: 20, duration: 100, selector: "id <> '\(deviceId)'")
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

