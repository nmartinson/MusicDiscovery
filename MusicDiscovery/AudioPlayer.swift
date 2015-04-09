//
//  AudioPlayer.swift
//  MusicDiscovery
//
//  Created by Nick Martinson on 4/6/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation

class AudioPlayer
{
    let kClientId = "9267f34373fa4cb1bf9ea94246a45566"
    var session:SPTSession?
    var player:SPTAudioStreamingController!
    
    init()
    {
        // if the player is nil, initialize it with the clientID
        player = SPTAudioStreamingController(clientId: kClientId)
    }
    
    // Makes this AudioPlayer class a singleton
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
    
}