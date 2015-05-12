//
//  SpotifyCommunication.swift
//  MusicDiscovery
//
//  Created by Nick Martinson on 4/21/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import Alamofire

class SpotifyCommunication
{
    /*******************************************************************************************
    *   Get the session object
    ********************************************************************************************/
    var session:SPTSession? {
        if let sessionObj:AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("SpotifySession")
        {
            // convert the stored session object back to SPTSession
            let sessionData = sessionObj as! NSData
            return NSKeyedUnarchiver.unarchiveObjectWithData(sessionData) as? SPTSession
        }
        return nil
    }
    
    
    /*******************************************************************************************
    *
    ********************************************************************************************/
    func getSongInfo(uri: NSURL, completion:(album: SPTPartialAlbum) -> Void)
    {
        SPTRequest.requestItemAtURI(uri, withSession: session) { (error, data) -> Void in
            if error == nil
            {
                let album = data.album as SPTPartialAlbum
//                println("SONG INFO\n\(album.name)")
//                println(album.smallestCover.imageURL)
                completion(album: album)
            }
        }
    }
    
}