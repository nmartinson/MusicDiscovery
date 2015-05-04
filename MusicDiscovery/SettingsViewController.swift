//
//  SettingsViewController.swift
//  MusicDiscovery
//
//  Created by Nick Martinson on 4/2/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer

class SettingsViewController: UIViewController, UITextFieldDelegate//, SPTAudioStreamingPlaybackDelegate
{
    @IBOutlet weak var searchField: UITextField!
    var request:NSURL?
    var session:SPTSession!
    var audioPlayer = AudioPlayer.sharedInstance
    let musicPlayer = MPMusicPlayerController.systemMusicPlayer()
    var user:User?
    
    override func viewDidLoad()
    {
        let info = MPNowPlayingInfoCenter.defaultCenter()
        let nowPlaying = info.nowPlayingInfo
        println("Now playing \(nowPlaying)")
        let command = MPRemoteCommandCenter.sharedCommandCenter()

        let notifications = NSNotificationCenter.defaultCenter()
        notifications.addObserver(self, selector: "getNot:", name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification, object: nil)
        
        musicPlayer.beginGeneratingPlaybackNotifications()
        
        // gets a hold of the session object
        if let sessionObj:AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("SpotifySession")
        {
            // convert the stored session object back to SPTSession
            let sessionData = sessionObj as! NSData
            session = NSKeyedUnarchiver.unarchiveObjectWithData(sessionData) as! SPTSession
        }

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        user = appDelegate.currentUser!
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        let info = MPNowPlayingInfoCenter.defaultCenter()
        let nowPlaying = info.nowPlayingInfo
        println("Now playing \(nowPlaying)")
    }
    
    
    func getNot(notification: NSNotification)
    {
        println(notification)
    }
    
    /*****************************************************************************************************
    *   Gets called as characters are typed in the search text field
    *   Searchs spotify for a song
    *****************************************************************************************************/
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if searchField.text != nil
        {
            let text = searchField.text
            
            SPTRequest.performSearchWithQuery(text, queryType: SPTSearchQueryType.QueryTypeTrack, offset: 0, session: session) { (error, response) -> Void in
                
                // make sure results arent nil
                if response != nil
                {
                    if let items = response.items as? [SPTPartialTrack]
                    {
                        if let item = items.first
                        {
                            self.request = item.playableUri
                            println(item.artists.first!.name)
                            println(item.name!)
                        }
                    }
                    else { println("No results") }
                }
            }
        }
        return true
    }
    
    /*****************************************************************************************************
    *   Logs out the current user.
    *   Sets the session object in NSUserDefaults to nil
    *   Presents the login view controller
    *****************************************************************************************************/
    @IBAction func logoutButtonPressed(sender: UIButton)
    {
        AudioPlayer.sharedInstance.player.logout { (error) -> Void in
            if error == nil
            {
                let loginView = self.storyboard!.instantiateViewControllerWithIdentifier("LoginView") as! LoginViewController
                let appDel = UIApplication.sharedApplication().delegate!
                appDel.window!?.rootViewController = loginView
                
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(nil, forKey: "SpotifySession")
            }
        }
    }
    
    /*****************************************************************************************************
    *
    *****************************************************************************************************/
    @IBAction func pauseButtonPressed(sender: UIButton)
    {
        if AudioPlayer.sharedInstance.player.isPlaying == true
        {
            AudioPlayer.sharedInstance.player.setIsPlaying(false, callback: { (error) -> Void in
                if error != nil
                {
                    println("error pausing")
                }
            })
        }
        else
        {
            AudioPlayer.sharedInstance.player.setIsPlaying(true, callback: { (error) -> Void in
                if error != nil
                {
                    println("error pausing")
                }
            })
        }
    }
    
    @IBAction func playButtonPressed(sender: UIButton)
    {
        if request != nil
        {
            audioPlayer.playUsingSession(request!)
            println("play")
        }
    }
 
    
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didChangeToTrack trackMetadata: [NSObject : AnyObject]!)
    {
        
        println("changed track to \(trackMetadata)")
    }
    
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didStartPlayingTrack trackUri: NSURL!) {
        println("started playing \(trackUri)")
    }
    
    
}