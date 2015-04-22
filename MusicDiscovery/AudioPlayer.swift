//
//  AudioPlayer.swift
//  MusicDiscovery
//
//  Created by Nick Martinson on 4/6/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation

class AudioPlayer: NSObject, SPTAudioStreamingPlaybackDelegate
{
    let kClientId = "9267f34373fa4cb1bf9ea94246a45566"
    var session:SPTSession?
    var player:SPTAudioStreamingController!

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
        self.player?.playURIs([request], fromIndex: 0, callback: { (error) -> Void in
            if error != nil
            {
                println("Playback error \(error)")
            }
            else
            {
                println(self.player.isPlaying)
            }
        })

    }
    
    /**********************************************************************************************************
    *   Gets called when the track changes
    *********************************************************************************************************/
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didChangeToTrack trackMetadata: [NSObject : AnyObject]!)
    {
        let artist = trackMetadata["SPTAudioStreamingMetadataArtistName"] as! String
        let track = trackMetadata["SPTAudioStreamingMetadataTrackName"] as! String
        let trackURI = trackMetadata["SPTAudioStreamingMetadataTrackURI"] as! String
        println("changed track to \(trackMetadata)")
        
        // Update the users current song in the database
    }
    
    /**********************************************************************************************************
    *   Gets called when a track starts
    *********************************************************************************************************/
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didStartPlayingTrack trackUri: NSURL!)
    {
        println("started playing \(trackUri)")
    }
}