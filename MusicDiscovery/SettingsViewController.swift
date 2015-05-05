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

class SettingsViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var searchRadiusLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var visibilityToggle: UISwitch!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var pauseButton: UIButton!
    var request:NSURL?
    var session:SPTSession!
    var audioPlayer = AudioPlayer.sharedInstance
    let musicPlayer = MPMusicPlayerController.systemMusicPlayer()
    var user:User?
    var radius:Int!
    var visible:Bool!
    
    /*****************************************************************************************************
    *
    *****************************************************************************************************/
    override func viewDidLoad()
    {
        radius = UserPreferences().getRadius()
        searchRadiusLabel.text = "Search radius: \(radius) m"
        visible = UserPreferences().isVisible()
        visibilityToggle.setOn(visible, animated: false)
        let status =  visible == true ? "on" : "off"
        visibilityLabel.text = "Visibility \(status)"

        
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
    
    /*****************************************************************************************************
    *
    *****************************************************************************************************/
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        println("TRACK LIST SIZE \(audioPlayer.player.trackListSize)")
        if audioPlayer.player.isPlaying
        {
            pauseButton.setTitle("Pause Music", forState: .Normal)
            pauseButton.hidden = false
        }
        else if audioPlayer.player.trackListSize > 0
        {
            pauseButton.setTitle("Play Music", forState: .Normal)
            pauseButton.hidden = false
        }
        else
        {
            pauseButton.hidden = true
        }
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(true)
        NSUserDefaults.standardUserDefaults().setInteger(radius, forKey: "searchRadius")
        
        //TO DO
        if visible != UserPreferences().isVisible()
        {
            NSUserDefaults.standardUserDefaults().setBool(visible, forKey: "visibility")
            //turn on or off visibility
        }
        
    }
    
    /*****************************************************************************************************
    *   Gets called as characters are typed in the search text field
    *   Searchs spotify for a song
    *****************************************************************************************************/
//    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
//        
//        if searchField.text != nil
//        {
//            let text = searchField.text
//            
//            SPTRequest.performSearchWithQuery(text, queryType: SPTSearchQueryType.QueryTypeTrack, offset: 0, session: session) { (error, response) -> Void in
//                
//                // make sure results arent nil
//                if response != nil
//                {
//                    if let items = response.items as? [SPTPartialTrack]
//                    {
//                        if let item = items.first
//                        {
//                            self.request = item.playableUri
//                            println(item.artists.first!.name)
//                            println(item.name!)
//                        }
//                    }
//                    else { println("No results") }
//                }
//            }
//        }
//        return true
//    }
    
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
        if audioPlayer.player.isPlaying == true
        {
            audioPlayer.player.setIsPlaying(false, callback: { (error) -> Void in
                if error == nil
                {
                    self.pauseButton.setTitle("Play Music", forState: .Normal)
                    self.pauseButton.hidden = false
                }
            })
        }
        else
        {
            audioPlayer.player.setIsPlaying(true, callback: { (error) -> Void in
                if error == nil
                {
                    self.pauseButton.setTitle("Pause Music", forState: .Normal)
                    self.pauseButton.hidden = false
                }
            })
        }
    }
    
    /*****************************************************************************************************
    *
    *****************************************************************************************************/
//    @IBAction func playButtonPressed(sender: UIButton)
//    {
//        if request != nil
//        {
//            audioPlayer.playUsingSession(request!)
//            println("play")
//        }
//    }
 
    /*****************************************************************************************************
    *
    *****************************************************************************************************/
    @IBAction func visibilityToggled(sender: UISwitch)
    {
        visible = sender.on
        let status =  visible == true ? "on" : "off"
        visibilityLabel.text = "Visibility \(status)"
    }
    
    @IBAction func searchRadiusChanged(sender: UISlider)
    {
        radius = Int(sender.value)
        searchRadiusLabel.text = "Search radius: \(radius) m"
    }
    
}