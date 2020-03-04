//
//  MainViewController.swift
//  ETH Checker
//
//  Created by Peter Kitsakos on 11/11/17.
//  Copyright © 2017 PeteyK. All rights reserved.
//

import UIKit
import Foundation
import UserNotifications

class MainViewController: UIViewController {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var reportedHashLabel: UILabel!
    @IBOutlet weak var effectiveHashLabel: UILabel!
    @IBOutlet weak var averageHashLabel: UILabel!
    @IBOutlet weak var unpaidBalLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    let defaults = UserDefaults.standard
    
    var effectiveHashGlobal: Double = 0
    var unpaidBalance: Double?
    
    var wallAddress: String! = UserDefaults.standard.string(forKey: "wallAddressValue")
    
    override func viewDidLoad() {
        addressLabel.text = wallAddress
        
        // Concatenation of api url
        let urlString1: String = "https://api.ethermine.org/miner/:"
        let urlString2: String = "/currentStats"
        let finalURL = URL(string: (urlString1 + wallAddress + urlString2))
        defaults.set(finalURL, forKey: "finalURLKey")
        
        // Call parser function to get info, not using return value
        pars(apiURL: finalURL)
        
        // Notifications
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "ETH Checker"
        
        // Retrieve value of unpaidBalDiffKey
        let keyString = defaults.double(forKey: "unpaidBalDiffKey")
        content.body = "ETH Mined: " + String(describing: keyString)
            
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: (60), repeats: true)
        
        let identifier = "ETHCheckNotification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        center.add(request, withCompletionHandler: { (error) in
            if error != nil{
                print("notification error.")
            }
        })
    
}
    
    func pars(apiURL: URL?) -> Void{
        if let url = apiURL{
            let task = URLSession.shared.dataTask(with: url as URL!) { (data, response, error) in
                if error == nil {
                    if let usableData = data { //JSONSerialization
                        let json = try? JSONSerialization.jsonObject(with: usableData, options: [])
                        if let dictionary = json as? [String: Any]{
                            
                            // Retrieve and print miner status
                            if let status: String = dictionary["status"] as? String{
                                if(status == "OK"){
                                    DispatchQueue.main.async{
                                        self.statusLabel.text = "Online"
                                    }
                                }
                            }
                            
                            // Assign data key of dictionary to an array named dataArr
                            if let dataDictionary: NSDictionary = dictionary["data"] as? NSDictionary{
                                
                                // Retrieve and print reported hashrate
                                if let reportedHash: Int = dataDictionary["reportedHashrate"] as? Int{
                                    DispatchQueue.main.async{
                                        self.reportedHashLabel.text = String(round((Double(reportedHash) / 1000000)*10)/10) + " mH/s"
                                    }
                                }
                                
                                // Retrieve and print effective hashrate
                                if let effectiveHash: Double = dataDictionary["currentHashrate"] as? Double{
                                    DispatchQueue.main.async{
                                        self.effectiveHashLabel.text = String(round((effectiveHash / 1000000)*10)/10) + " mH/s"
                                        self.effectiveHashGlobal = round((effectiveHash / 1000000)*10)/10
                                    }
                                }
                                
                                // Retrieve and print average hashrate
                                if let averageHash: Double = dataDictionary["averageHashrate"] as? Double{
                                    DispatchQueue.main.async{
                                        self.averageHashLabel.text = String(round((averageHash / 1000000)*10)/10) + " mH/s"
                                    }
                                }
                                
                                // Retrieve and print unpaid balance
                                if let unpaidBal: Double = dataDictionary["unpaid"] as? Double{
                                    DispatchQueue.main.async {
                                        let unpaidBalDoub = round((unpaidBal / 1000000000000000000)*100000)/100000
                                        self.unpaidBalLabel.text = String(unpaidBalDoub) + " ETH"
                                        // Assign progress to percentage out of 0.05 (Payout threshole)
                                        let fractionalProgress: Float = Float(unpaidBalDoub) / 0.05
                                        // Display unpaid balance progress in progress view on storyboard
                                        self.progressView.setProgress(fractionalProgress, animated: true)
                                    }
                                }
                                
                            }
                            
                        }
                    }
                }
            }
            task.resume()
        }
    }
}
