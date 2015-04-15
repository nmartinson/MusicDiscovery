//
//  User.swift
//  MusicDiscovery
//
//  Created by Nick Martinson on 4/10/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation

class User
{
    var realName:String!
    var profilePicture:UIImage?
    var currentSongURL:NSURL?
    
    init(realName:String, profilePicture: UIImage, currentSongURL: NSURL)
    {
        self.realName = realName
        self.profilePicture = profilePicture
        self.currentSongURL = currentSongURL
    }
    
    init(realName:String, currentSongURL: NSURL)
    {
        self.realName = realName
        self.currentSongURL = currentSongURL
    }
    
}