//
//  TwilioController.swift
//  Maptest
//
//  Created by Greg Hughes on 4/10/19.
//  Copyright © 2019 Greg Hughes. All rights reserved.
//

import UIKit

class TwilioController {
    
    
    static var shared = TwilioController()
    var message = ""
    
    
    let baseURL = URL(string: "https://AC89a4c7bec68d8edb9dbf53effc5a6536:00e9b90f57b10e476f5e928bf797db21@api.twilio.com/2010-04-01/Accounts/AC89a4c7bec68d8edb9dbf53effc5a6536/Messages")
    
    
    fileprivate func formatText(message: String)->String{
        
        let formattedMessage = message.split(separator: " ").map({$0 + "+"}).joined()
        
        return formattedMessage
    }
    
    
    

    func sendText(message: String, to phoneNumber: String, completion: @escaping ()->()){
        
        
        guard let baseURL = baseURL else {print("🔥❇️>>>\(#file) \(#line): guard ket failed<<<"); return  }
        var request = URLRequest(url: baseURL)
        
        let postBody = "From=13852501323&To=18017225596&Body=\(message)".data(using: .utf8)

//        1627112
//        3201172
        request.httpBody = postBody
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic AC89a4c7bec68d8edb9dbf53effc5a6536:00e9b90f57b10e476f5e928bf797db21", forHTTPHeaderField: "Authorization")
        
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("❌ There was an error in \(#function) \(error) : \(error.localizedDescription)")
                completion()
                return
            }
            
            guard let data = data, let dataAsAString = String(data: data, encoding: .utf8) else {print("🔥❇️>>>\(#file) \(#line): guard ket failed<<<"); return  }
            
//            print("🆚\(dataAsAString)")
            
        }.resume()   
    }
}

