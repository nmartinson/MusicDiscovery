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
    private var imageURL:String?
    private var location:CLLocation?
    private var latitude:String!
    private var longitude:String!
    private var albumName:String?
    
    init(realName:String, userID:String, profilePicture: String, currentSongURL: NSURL, artist:String, song:String, album:String, location:CLLocation)
    {
        self.realName = realName
        self.userID = userID
        self.imageURL = profilePicture
        self.currentSongURL = currentSongURL
        self.songName = song
        self.artistName = artist
        self.albumName = album
        
        self.location = location
        self.latitude = "\(location.coordinate.latitude)"
        self.longitude = "\(location.coordinate.longitude)"
    }
    
    init(realName:String, userID:String, profilePicture: String, currentSongURL: NSURL, location:CLLocation)
    {
        self.realName = realName
        self.userID = userID
        self.imageURL = profilePicture
        self.currentSongURL = currentSongURL
        
        
        self.location = location
        self.latitude = "\(location.coordinate.latitude)"
        self.longitude = "\(location.coordinate.longitude)"
    }
    
    init(realName:String, userID:String, profilePicture: String, currentSongURL: NSURL)
    {
        self.realName = realName
        self.userID = userID
        self.imageURL = profilePicture
        self.currentSongURL = currentSongURL
    }
    
    init(realName:String, userID:String, profilePicture: String)
    {
        self.realName = realName
        self.userID = userID
        self.imageURL = profilePicture
    }
    
    init(realName:String, userID:String, currentSongURL: NSURL)
    {
        self.realName = realName
        self.userID = userID
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
    
    func setSongName(name:String)
    {
        self.songName = name
    }
    
    func getSongName() -> String?
    {
        return songName
    }
    
    func setArtistName(name:String)
    {
        self.artistName = name
    }
    
    func getArtistName() -> String?
    {
        return artistName
    }
    
    func getImageURL() -> String?
    {
        return imageURL
    }
    
    func setAlbumName(name:String)
    {
        self.albumName = name
    }
    
    func getAlbumName() -> String?
    {
        return albumName
    }
    
    func getLocation2D() -> NSDictionary {
        return ["latitude" : self.latitude, "longitude" : self.longitude]
    }
    
    func getLocation() -> CLLocation?
    {
        return location
    }
}