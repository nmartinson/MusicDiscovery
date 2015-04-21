//
//  BluemixCommunication.swift
//  MusicDiscovery
//
//  Created by Nick Martinson on 4/21/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import Alamofire

class BluemixCommunication
{
    let userURL = "http://musicdiscovery.mybluemix.net/User"
    let newUserAction = "100"
    let getUserAction = "101"
    let updateCurrentSongAction = "102"
    let getNearbyUsersAction = "103"
    let newUserCreationSuccess = "1000"
    let newUserCreationFailure = "1001"
    let getUserFailure = "1011"
    let updateCurrentSongSuccess = "1020"
    let updateCurrentSongFailure = "1021"
    let getNearbyUsersFailure = "1031"
    
    
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func getNearbyUsers(userId: String, completion:(users: [User]) -> Void)
    {
        let radius = "1000"
        var details:Dictionary<String,AnyObject>?
        details = ["error": "", "success": false]
        let params = ["action": getNearbyUsersAction, "userId": userId, "radius": radius]
        
        Alamofire.request(.GET, userURL, parameters: params).responseJSON { (_, response, rawJSON, _) -> Void in
            var json = JSON(rawJSON!)
            completion(users: [])
        }
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func getUserInfo(userId: String, completion:(users: [User]) -> Void)
    {
        var details:Dictionary<String,AnyObject>?
        details = ["error": "", "success": false]
        let params = ["action": getUserAction, "userId": userId]
        
        Alamofire.request(.GET, userURL, parameters: params).responseJSON { (_, response, rawJSON, _) -> Void in
            
            if rawJSON != nil
            {
                var json = JSON(rawJSON!)
                println("GET USER\n\(rawJSON)")
                let currentSong = json["currentSong"].stringValue
                let id = json["id"].stringValue
                let lat = json["lat"].stringValue
                let lon = json["lon"].stringValue
                let profilePicURL = json["profilePictureUrl"].stringValue
                let lastSongCSV = json["lastSongsCSV"].stringValue
            }
            
            completion(users: [])
        }
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func updateCurrentSong(userId: String, song:String, completion:(users: [User]) -> Void)
    {
        var details:Dictionary<String,AnyObject>?
        details = ["error": "", "success": false]
        let params = ["action": updateCurrentSongAction, "userId": userId, "newSong": song]
        
        Alamofire.request(.POST, userURL, parameters: params).responseJSON { (_, response, rawJSON, _) -> Void in
            var json = JSON(rawJSON!)
            
            completion(users: [])
        }
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func createNewUser(spotifyId: String, name:String, lat:String, lon:String, profilePicture:String, completion:(users: [User]) -> Void)
    {
        var details:Dictionary<String,AnyObject>?
        details = ["error": "", "success": false]
        let params = ["action": newUserAction, "id": spotifyId, "name": name, "lat":"92", "lon":"94", "profilePictureUrl":profilePicture]
        
        Alamofire.request(.POST, userURL, parameters: params).responseString { (_, response, rawString, _) -> Void in
//            var json = JSON(rawJSON!)
            println("CREATE USER \(rawString)")
//            completion(users: [])
        }
    }
    
}