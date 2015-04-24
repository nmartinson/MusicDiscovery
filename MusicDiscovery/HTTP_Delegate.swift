//
//  HTTP_Delegate.swift
//  MusicDiscovery
//
//  Created by Dillon McCusker on 4/22/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import Alamofire

class HTTP_Delegate {
    
    var usersURL = "http://musicdiscovery.mybluemix.net/User"
    
    init() {
    }
    
//    Name: Get Nearby Users
//    URL: http://musicdiscovery.mybluemix.net/User
//    Method: Get
//    Action Code: 103
//    Returns: Data if users nearby, 1031 for none
//    Description: Fetches the nearby users within a specified radius
//    Parameters: 
//          1) userId
//          2) radius
//          3) action
    
    func getUsersInProximity(userId: String, radius: String, completion: (result:String) -> Void) {
        
        Alamofire.request(.GET, usersURL, parameters: ["userId":userId, "radius": radius, "action":"103"]).responseString { ( _, HTTP_Response, results_JSON_string, _)  -> Void in
//            println("getNotesInProximty HTTP response: \(HTTP_Response)")
            completion(result: results_JSON_string!)
        }
    }
    
}