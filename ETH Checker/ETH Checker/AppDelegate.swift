//
//  AppDelegate.swift
//  ETH Checker
//
//  Created by Peter Kitsakos on 11/11/17.
//  Copyright © 2017 PeteyK. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.shared.setMinimumBackgroundFetchInterval(60)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("complete")
        
        getData()
    }
    
    func getData() -> Void{
        let defaults = UserDefaults.standard
        
        let apiURL = defaults.url(forKey: "wallAddressValue")
        
        if let url = apiURL{
            let task = URLSession.shared.dataTask(with: url as URL!) { (data, response, error) in
                if error == nil {
                    if let usableData = data { //JSONSerialization
                        let json = try? JSONSerialization.jsonObject(with: usableData, options: [])
                        if let dictionary = json as? [String: Any]{
                            if let dataDictionary: NSDictionary = dictionary["data"] as? NSDictionary{
                                if let unpaidBal: Double = dataDictionary["unpaid"] as? Double{
                                    let unpaidBalDoub = round((unpaidBal / 1000000000000000000)*100000)/100000
                                    var unpaidBalNew = defaults.double(forKey: "unpaidBalNewKey")
                                    defaults.set(unpaidBalNew, forKey: "unpaidBalOldKey")
                                    
                                    defaults.set(unpaidBalDoub, forKey: "unpaidBalNewKey")
                                    
                                    let unpaidBalOld = defaults.double(forKey: "unpaidBalOldKey")
                                    
                                    unpaidBalNew = defaults.double(forKey: "unpaidBalNewKey")
                                    
                                    let unpaidBalDiff = unpaidBalNew - unpaidBalOld
                                    
                                    defaults.set(unpaidBalDiff, forKey: "unpaidBalDiffKey")
                                }
                            }
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground.
    }


}

