//
//  BluemixCommunication.swift
//  MusicDiscovery
//
//  Created by Nick Martinson on 4/21/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import Alamofire

/******************************************************************************************
*
******************************************************************************************/
extension Alamofire.Request
{
    class func imageResponseSerializer() -> Serializer{
        return { request, response, data in
            if( data == nil) {
                return (nil,nil)
            }
            let image = UIImage(data: data!, scale: UIScreen.mainScreen().scale)
            
            return (image, nil)
        }
    }
    
    func responseImage(completionHandler: (NSURLRequest, NSHTTPURLResponse?, UIImage?, NSError?) -> Void) -> Self{
        return response(serializer: Request.imageResponseSerializer(), completionHandler: { (request, response, image, error) in
            completionHandler(request, response, image as? UIImage, error)
        })
    }
}

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
        let radius = "1000000000000"
        var details:Dictionary<String,AnyObject>?
        details = ["error": "", "success": false]
        let params = ["action": getNearbyUsersAction, "userId": userId, "radius": radius]
        
        Alamofire.request(.GET, userURL, parameters: params).responseJSON { (_, response, rawJSON, _) -> Void in
            println("NEARBY USERS\n\(rawJSON)")
            if rawJSON != nil
            {
                var users:[User] = []
                var json = JSON(rawJSON!)
                for(var i = 0; i < json.count; i++)
                {
                    let currentSong = json[i]["currentSong"].stringValue
                    let id = json[i]["id"].stringValue
                    let lat = json[i]["lat"].stringValue
                    let lon = json[i]["lon"].stringValue
                    let profilePicURL = json[i]["profilePictureUrl"].stringValue
                    let lastSongCSV = json[i]["lastSongsCSV"].stringValue
                    
                    let coords = CLLocation(latitude: (lat as NSString).doubleValue, longitude: (lon as NSString).doubleValue)
                    let user = User(realName: "", userID: id, profilePicture: profilePicURL, currentSongURL: NSURL(string: currentSong)!, location: coords)
                    users.append(user)
                }
                completion(users: users)
            }
            else
            {
                completion(users: [])
            }
        }
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func getUserInfo(userId: String, completion:(user: User?) -> Void)
    {
        var details:Dictionary<String,AnyObject>?
        details = ["error": "", "success": false]
        let params = ["action": getUserAction, "userId": userId]
        
        Alamofire.request(.GET, userURL, parameters: params).responseJSON { (_, response, rawJSON, _) -> Void in
            
            if rawJSON != nil
            {
                var json = JSON(rawJSON!)
                let currentSong = json["currentSong"].stringValue
                let id = json["id"].stringValue
                let lat = json["lat"].stringValue
                let lon = json["lon"].stringValue
                let profilePicURL = json["profilePictureUrl"].stringValue
                let lastSongCSV = json["lastSongsCSV"].stringValue
                let user = User(realName: "", userID: id, profilePicture: profilePicURL, currentSongURL: NSURL(string: currentSong)!)
                completion(user: user)
            }
            else
            {
                completion(user: nil)
            }
        }
    }
    
    /******************************************************************************************
    *
    ******************************************************************************************/
    func updateCurrentSong(userId: String, song:String)
    {
        var details:Dictionary<String,AnyObject>?
        details = ["error": "", "success": false]
        let params = ["action": updateCurrentSongAction, "userId": userId, "newSong": song]
        
        Alamofire.request(.POST, userURL, parameters: params).responseString { (_, response, string, _) -> Void in
            if string! == "1000"
            {
                println("update song success")
            }
            else if string! == "1001"
            {
                println("Update song failure")
            }
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