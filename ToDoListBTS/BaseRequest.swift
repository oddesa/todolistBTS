//
//  BaseRequest.swift
//  ToDoListBTS
//
//  Created by Jehnsen Hirena Kane on 07/01/22.
//

import Foundation

class BaseRequest: NSObject {

    static func getChecklist(url: String, header: String,completionHandler: @escaping (Any) -> Void) {
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["Authorization": "Bearer \(header)"]
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                if let dataFromAPI = data {
                    completionHandler(dataFromAPI)
                }
            }
        })

        dataTask.resume()
    }
    
    
    static func POST(url: String,
                     header: String,
                     name: String,
                     successCompletion: @escaping (Any) -> Void,
                     failCompletion: @escaping (String) -> Void) {
        
        //init request
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)

        let jsonString = """
                            {"name":"\(name)"}
                         """
        let jsonSessionData = jsonString.data(using: .utf8)!
        let jsonSession = try! JSONSerialization.jsonObject(with: jsonSessionData, options: .allowFragments)
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonSession)
        
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = ["Authorization": "Bearer \(header)"]
        request.httpBody = jsonData
        
        //init session
        let session = URLSession.shared

        //init datatask dengan
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
                failCompletion(error?.localizedDescription ?? "Error make a connection to server")
            } else {
                if let response = response {
                    print(response)
                    successCompletion(response)
                }
            }
        })

        dataTask.resume()
        
    }
    
    
}
