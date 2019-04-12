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
    
    let baseURL = URL(string: "https://AC89a4c7bec68d8edb9dbf53effc5a6536:00e9b90f57b10e476f5e928bf797db21@api.twilio.com/2010-04-01/Accounts/AC89a4c7bec68d8edb9dbf53effc5a6536/Messages")
//    "https://demo.twilio.com/welcome/sms/reply/.json"
//    https://{AccountSid}:{AuthToken}@api.twilio.com/2010-04-01/Accounts
//    Messages=From=%2B13852501323&To=%2B18017225596&Body=Hello"
    func postMessage(message: String, completion: @escaping ()->()){
        
        
        guard let baseURL = baseURL else {print("🔥❇️>>>\(#file) \(#line): guard ket failed<<<"); return  }

        var request = URLRequest(url: baseURL)
        
        let string = "From=13852501323&To=18017225596&Body=hello".data(using: .utf8)

        
        request.httpBody = string
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
            
            print("🆚\(dataAsAString)")
            
        }.resume()
        
        
        
    }
    
//    fileprivate func dataFromUrl(url: Message) -> Data{
//
//        do {
////            let data = try Data(contentsOf: url)
//            return data
//        }catch{
//            print("❌ There was an error in \(#function) \(error) : \(error.localizedDescription)")
//            return Data()
//        }
//    }
    
    
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
    var From : String
    var To : String
    var Body : String
}
