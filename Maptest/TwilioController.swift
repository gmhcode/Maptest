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
    
    let baseURL = URL(string: "https://api.twilio.com/2010-04-01/Accounts/AC89a4c7bec68d8edb9dbf53effc5a6536/Messages")
    
    
    func postMessage(message: String, completion: @escaping ()->()){
        
        let tempMessage = Message(to: "8017225596", body: message)
        
        guard let baseURL = baseURL else {print("🔥❇️>>>\(#file) \(#line): guard ket failed<<<"); return  }
        print("🈲\(baseURL)")
        var request = URLRequest(url: baseURL)
        
        
        request.httpBody = jsonEncode(message: tempMessage)
        request.httpMethod = "POST"
        request.setValue("Basic AC89a4c7bec68d8edb9dbf53effc5a6536:00e9b90f57b10e476f5e928bf797db21", forHTTPHeaderField: "Authorization")
        
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("❌ There was an error in \(#function) \(error) : \(error.localizedDescription)")
                completion()
                return
            }
            
            guard let data = data, let dataAsAString = String(data: data, encoding: .utf8) else {print("🔥❇️>>>\(#file) \(#line): guard ket failed<<<"); return  }
            
            print("🆚\(dataAsAString)")
            
        }.resume()
        
        
        
    }
    
    fileprivate func jsonEncode(message: Message) -> Data{
        
        let jsonEncoder = JSONEncoder()
        
        do {
            let data = try jsonEncoder.encode(message)
            return data
        } catch {
            print("❌❌ There was an error in \(#function) \(error) : \(error.localizedDescription)")
            return Data()
        }
    }
}

struct Message: Codable {
    var to : String
    var body : String
}
