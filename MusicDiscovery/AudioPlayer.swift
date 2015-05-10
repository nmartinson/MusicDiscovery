//
//  AudioPlayer.swift
//  MusicDiscovery
//
//  Created by Nick Martinson on 4/6/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation

protocol AudioPlayerDelegate
{
    func notAPremiumUser()
}

class AudioPlayer: NSObject, SPTAudioStreamingPlaybackDelegate
{
    let kClientId = "9267f34373fa4cb1bf9ea94246a45566"
    var session:SPTSession?
    var player:SPTAudioStreamingController!
    var user:User?
    var delegate:AudioPlayerDelegate?
    var premium:Bool?


    override init()
    {
        super.init()
        // if the player is nil, initialize it with the clientID
        player = SPTAudioStreamingController(clientId: kClientId)
        player.playbackDelegate = self
    }
    
    /**********************************************************************************************************
    *   Makes this AudioPlayer class a singleton
    *********************************************************************************************************/
    public class var sharedInstance: AudioPlayer{
        struct SharedInstance {
            static let instance = AudioPlayer()
        }
        return SharedInstance.instance
    }
    
    func isPremium() -> Bool
    {
        if !self.player.loggedIn || premium == false
        {
            self.delegate?.notAPremiumUser()
            return false
        }
        return true
    }
    
    /*****************************************************************************************************
    *   Play the request that is passed in
    *****************************************************************************************************/
    func playUsingSession(request: NSURL)
    {
        if isPremium()
        {
            self.player?.playURIs([request], fromIndex: 0, callback: { (error) -> Void in
                if error != nil
                {
                    println("Playback error \(error)")

                }
            })
        }
    }
    
    /**********************************************************************************************************
    *   Gets called when the track changes
    *********************************************************************************************************/
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didChangeToTrack trackMetadata: [NSObject : AnyObject]!)
    {
        if trackMetadata != nil
        {
            
            let artist = trackMetadata["SPTAudioStreamingMetadataArtistName"] as! String
            let track = trackMetadata["SPTAudioStreamingMetadataTrackName"] as! String
            let trackURI = trackMetadata["SPTAudioStreamingMetadataTrackURI"] as! String
            let album = trackMetadata["SPTAudioStreamingMetadataAlbumName"] as! String
            println("changed track to \(trackMetadata)")
            
            // Update the users current song and location in the database
            BluemixCommunication().updateCurrentSong(user!.getUserID(), track: track, album: album, artist: artist, URI: trackURI)
            BluemixCommunication().updateLocation(user!.getUserID(), lat: LocationHandler.sharedInstance.latitude, lon: LocationHandler.sharedInstance.longitude)
        }
    }
    
    /**********************************************************************************************************
    *   Gets called when a track starts
    *********************************************************************************************************/
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didStartPlayingTrack trackUri: NSURL!)
    {
        println("started playing \(trackUri)")
    }
    

    
}