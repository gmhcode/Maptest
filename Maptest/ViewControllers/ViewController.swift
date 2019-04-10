//
//  ViewController.swift
//  Maptest
//
//  Created by Greg Hughes on 4/10/19.
//  Copyright © 2019 Greg Hughes. All rights reserved.
//

import UIKit
import MessageUI
class ViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TwilioController.shared.postMessage(message: "hello") {
            
        }
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    
    
    
    
    func displayMessageInterface(){
        
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        
        // Configure the fields of the interface
        composeVC.recipients = ["8017225596"]
        composeVC.body = "hello"
        
        //present the view controller modally
        if MFMessageComposeViewController.canSendText(){
            self.present(composeVC, animated: true)
            
        } else {
            print("cant send messages")
        }
    }
    


    
    
    @IBAction func sendTextButtonTapped(_ sender: Any) {
        displayMessageInterface()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
