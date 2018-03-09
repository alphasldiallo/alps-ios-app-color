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
    
    let colors = ["yellow": UIColor.yellow, "red": UIColor.red, "purple": UIColor.purple, "orange": UIColor.orange, "magenta": UIColor.magenta, "lightgray": UIColor.lightGray, "green": UIColor.green, "cyan": UIColor.cyan]
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let config = MatchMoreConfig(apiKey: "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiJ9.eyJpc3MiOiJhbHBzIiwic3ViIjoiOGYyOGY4YjYtZWY1Ny00NGE3LWFlMjUtOWZjZjYyMWNmZDM4IiwiYXVkIjpbIlB1YmxpYyJdLCJuYmYiOjE1MTEyNzUzMDEsImlhdCI6MTUxMTI3NTMwMSwianRpIjoiMSJ9.xE6GgETfzn7t3F-0oopojs_TZGEGw2v97PT4_ZMmsi715fwlPCMzbxDC1GgL_KOLrDMO_alaDwFDql81ILYI_A")
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
            
            //             TEST
            MatchMore.createPublicationForMainDevice(publication: Publication(topic: "color", range: 20, duration: 100, properties: ["color": "yellow"]), completion: { result in
                switch result {
                case .success(let publication):
                    print("🏔 Pub was created: 🏔\n\(publication.encodeToJSON())")
                //                    self.currentPub = publication
                case .failure(let error):
                    print("🌋 \(String(describing: error?.message)) 🌋")
                }
            })
            }
        return true
        }
    
    // Subscriptions
    
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

