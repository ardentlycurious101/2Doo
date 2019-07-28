//
//  AppDelegate.swift
//  2Doo
//
//  Created by Elina Lua Ming on 7/22/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        let realm = try! Realm()

//        do {
//            let realm = try Realm()
//        } catch {
//            print("Error initializing new realm : \(error)")
//        }
        
        return true
    }
}

