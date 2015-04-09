//
//  SettingsViewController.swift
//  MusicDiscovery
//
//  Created by Nick Martinson on 4/2/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var searchField: UITextField!
    var request:NSURL?
    var session:SPTSession!
    var audioPlayer = AudioPlayer.sharedInstance
    
    
    override func viewDidLoad()
    {
        // gets a hold of the session object
        if let sessionObj:AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("SpotifySession")
        {
            // convert the stored session object back to SPTSession
            let sessionData = sessionObj as NSData
            session = NSKeyedUnarchiver.unarchiveObjectWithData(sessionData) as SPTSession
            //            appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate!
            
        }
    }
    //
    //    override func viewDidAppear(animated: Bool) {
    //        locationHandler = LocationHandler()
    //    }
    
    
    
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
    
    
    
    @IBAction func playButtonPressed(sender: UIButton)
    {
        if request != nil
        {
            audioPlayer.playUsingSession(request!)
            println("play")
        }
    }
    
    
}