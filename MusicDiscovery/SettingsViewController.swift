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
    
    override func viewDidLoad() {
        if let sessionObj:AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("SpotifySession")
        {
            // convert the stored session object back to SPTSession
            let sessionData = sessionObj as NSData
            session = NSKeyedUnarchiver.unarchiveObjectWithData(sessionData) as SPTSession
        }
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if searchField.text != nil
        {
            let text = searchField.text.stringByReplacingOccurrencesOfString(" ", withString: "-")
            println("session \(session)")

            SPTRequest.performSearchWithQuery(text, queryType: SPTSearchQueryType.QueryTypeTrack, offset: 0, session: session) { (error, response) -> Void in
                if response != nil
                {
                    let items = response.items!
                    let first = items[0] as SPTPartialTrack
                    self.request = first.playableUri
                    println(first)
                }
            }
        }
        
        return true
    }
    
    @IBAction func playButtonPressed(sender: UIButton)
    {
        println("request \(request)")
        println("session \(session)")
        AppDelegate().playUsingSession(session, request: request!)
    }

}