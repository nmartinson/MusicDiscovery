//
//  SpotifyWebAPI.swift
//  MusicDiscovery
//
//  Created by Nick Martinson on 4/14/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import Alamofire

class SpotifyWebAPI
{
    let meURL = NSURL(string: "https://api.spotify.com/v1/me")!
    let userURL = "https://api.spotify.com/v1/users"
    
    func getMeInfo(session: SPTSession)
    {
        let mutableRequest = NSMutableURLRequest(URL: meURL)
        mutableRequest.setValue("Bearer \(session.accessToken)", forHTTPHeaderField: "Authorization")
        mutableRequest.setValue("Accept", forHTTPHeaderField: "application/json")
        let request = Alamofire.request(mutableRequest)
        
        request.responseJSON{(_,response, rawJSON, error) in
            if error == nil
            {
                let json = JSON(rawJSON!)
                let userID = json["id"].stringValue
            }
        }
    }
    
    func getMyPlaylists(session:SPTSession, userID: String)
    {
        
        let URL = NSURL(string: "\(userURL)/\(userID)/playlists")
        let mutableRequest = NSMutableURLRequest(URL: URL!)
        mutableRequest.setValue("Bearer \(session.accessToken)", forHTTPHeaderField: "Authorization")
        mutableRequest.setValue("Accept", forHTTPHeaderField: "application/json")
        let request = Alamofire.request(mutableRequest)
        
        request.responseJSON{(_,response, rawJSON, error) in
            if error == nil
            {
                let json = JSON(rawJSON!)

                let count = json["total"].intValue
                for(var i = 0; i < count; i++)
                {
                    println(json["items"][i]["name"].stringValue)
                }
            }
        }
    }
    
    
}