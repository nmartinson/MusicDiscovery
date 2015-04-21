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
    private var realName:String!
    private var profilePicture:UIImage?
    private var currentSongURL:NSURL?
    private var userID:String!
    private var songName:String?
    private var artistName:String?
    
    init(realName:String, userID:String, profilePicture: UIImage, currentSongURL: NSURL)
    {
        self.realName = realName
        self.userID = userID
        self.profilePicture = profilePicture
        self.currentSongURL = currentSongURL
    }
    
    init(realName:String, currentSongURL: NSURL)
    {
        self.realName = realName
        self.currentSongURL = currentSongURL
    }
    
    func setCurrentSong(song:NSURL)
    {
        self.currentSongURL = song
    }
    
    func getCurrentSong() -> NSURL?
    {
        return currentSongURL
    }
    
    func setRealName(name:String)
    {
        self.realName = name
    }
    
    func getRealName() -> String
    {
        return realName
    }
    
    func getProfilePicture() -> UIImage?
    {
        return profilePicture
    }
    
    func getUserID() -> String
    {
        return userID
    }
    
    func getSongName() -> String?
    {
        return songName
    }
    
    func getArtistName() -> String?
    {
        return artistName
    }
}