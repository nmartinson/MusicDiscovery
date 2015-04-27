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


    override init()
    {
        // if the player is nil, initialize it with the clientID
        player = SPTAudioStreamingController(clientId: kClientId)
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
    
    /*****************************************************************************************************
    *   Play the request that is passed in
    *****************************************************************************************************/
    func playUsingSession(request: NSURL)
    {
        player.playbackDelegate = self
        if !self.player.loggedIn
        {
            self.delegate?.notAPremiumUser()
        }
        self.player?.playURIs([request], fromIndex: 0, callback: { (error) -> Void in
            if error != nil
            {
                println("Playback error \(error)")

            }
        })

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
            println("changed track to \(trackMetadata)")
            
            // Update the users current song in the database
            BluemixCommunication().updateCurrentSong(user!.getUserID(), song: trackURI)
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