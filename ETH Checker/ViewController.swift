//
//  ViewController.swift
//  ETH Checker
//
//  Created by Peter Kitsakos on 11/11/17.
//  Copyright © 2017 PeteyK. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        submitButton.layer.cornerRadius = 5
        initNotificationSetupCheck()
        
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        self.addressField.resignFirstResponder()
        
        // Assign entered value to variable
        let wallAddress: String? = addressField.text
        
        // Check if field is empty
        if(wallAddress?.isEmpty)!{
            let alertController = UIAlertController(title: "Invalid Address", message: "Please enter a valid wallet address", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        
        // Store Data
        UserDefaults.standard.set(wallAddress, forKey: "wallAddressValue")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }

    func initNotificationSetupCheck() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
        { (success, error) in
            if success {
                print("Permission Granted")
            } else {
                print("There was a problem!")
            }
        }
    }
}

