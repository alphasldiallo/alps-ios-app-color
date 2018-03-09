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
//    var exampleMatchHandler: ExampleMatchHandler!
    let colors = ["yellow": UIColor.yellow, "red": UIColor.red, "purple": UIColor.purple, "orange": UIColor.orange, "magenta": UIColor.magenta, "lightgray": UIColor.lightGray, "green": UIColor.green, "cyan": UIColor.cyan]
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // swiftlint:disable line_length
        let config = MatchMoreConfig(apiKey: "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiJ9.eyJpc3MiOiJhbHBzIiwic3ViIjoiYzM5MzFhNDgtYmQ4Mi00NDVmLWI2NTYtMTEyN2ZkY2FiYjBlIiwiYXVkIjpbIlB1YmxpYyJdLCJuYmYiOjE1MTExODMxOTgsImlhdCI6MTUxMTE4MzE5OCwianRpIjoiMSJ9.ZvZ-cWwlUJv_dPpn1pSUoHoRT-7yoH4HjFqofnaDxMk5ZSwh0v9yn2HmnxejixinApGr-P-PAXcbisFuREVgPA")
        MatchMore.configure(config)
        
        MatchMore.startUsingMainDevice { result in
            guard case .success(let mainDevice) = result else { print(result.errorMessage ?? ""); return }
            print("🏔 Using device: 🏔\n\(mainDevice.encodeToJSON())")
            
            
            
            // Start Monitoring Matches
//            self.exampleMatchHandler = ExampleMatchHandler { matches, _ in
//                print("🏔 You've got new matches!!! 🏔\n\(matches.map { $0.publication?.encodeToJSON() })")
//                // Color the background according to the match
//                guard let properties = matches[0].publication?.properties else {
//                    print("No properties.")
//                    return
//                }
//                let color = properties["color"] as? String
//                self.window?.rootViewController?.view.backgroundColor = self.colors[color!]
//            }
//            MatchMore.matchDelegates += self.exampleMatchHandler
            
            
            
            MatchMore.startUpdatingLocation()
            
            // TEST
//            MatchMore.createPublicationForMainDevice(publication: Publication(topic: "color", range: 20, duration: 100, properties: ["color": "blue"]), completion: { result in
//                switch result {
//                case .success(let publication):
//                    print("🏔 Pub was created: 🏔\n\(publication.encodeToJSON())")
////                    self.currentPub = publication
//                case .failure(let error):
//                    print("🌋 \(String(describing: error?.message)) 🌋")
//                }
//            })
        }
        return true
    }
    
    // Subscriptions
    
    
}
