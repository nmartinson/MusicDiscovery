//
//  ViewController.swift
//  SpotifyTest
//
//  Created by Nick Martinson on 4/1/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, SPTAuthViewDelegate
{
    let auth = SPTAuth.defaultInstance()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    /**********************************************************************************************************
    *   Checks to see if there is a valid Spotify session saved in the defaults. If so, it checks if it is still
    *   valid. If not, it refreshes the stored session
    *********************************************************************************************************/
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(true)
        if let sessionObj:AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("SpotifySession")
        {
            // convert the stored session object back to SPTSession
            let sessionData = sessionObj as! NSData
            let session = NSKeyedUnarchiver.unarchiveObjectWithData(sessionData) as! SPTSession
            println(session)
            // check if the retrieved session is still valid and that we can refresh the token
            if !session.isValid() && auth.hasTokenRefreshService
            {
                // Renew the session
                SPTAuth.defaultInstance().renewSession(auth.session, callback: { (error, newSession) -> Void in
                    if error != nil { println("Renew session error") }
                    else
                    {
                        
                        // store the refreshed session in user defaults
                        let sessionDataNew = NSKeyedArchiver.archivedDataWithRootObject(newSession)
                        NSUserDefaults.standardUserDefaults().setObject(sessionDataNew, forKey: "SpotifySession")
                        AudioPlayer.sharedInstance.session = newSession
                        AudioPlayer.sharedInstance.player?.loginWithSession(newSession, callback: { (error) -> Void in
                            println("player login error \(error)")
                        })
                    }
                })
            }
            else if session.isValid()
            {
                AudioPlayer.sharedInstance.player?.loginWithSession(session, callback: { (error) -> Void in
                    println("player login error \(error)")
                    
                })
                performSegueWithIdentifier("LoggedInSegue", sender: self)
            }
        }
        
    }
    
    /**********************************************************************************************************
    *   This creates the Spotify modal login view
    *********************************************************************************************************/
    @IBAction func loginPressed(sender: AnyObject)
    {
        // create the Spotify login modal view
        let authView = SPTAuthViewController.authenticationViewController()
        authView.delegate = self
        authView.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
        authView.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        self.definesPresentationContext = true
        presentViewController(authView, animated: true, completion: nil)
        self.modalPresentationStyle = .CurrentContext
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    /**********************************************************************************************************
    *   SPOTIFY DELEGATE METHODS
    *********************************************************************************************************/
    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didFailToLogin error: NSError!)
    {
        println("Log in failed")
    }
    
    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didLoginWithSession session: SPTSession!)
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        let sessionData = NSKeyedArchiver.archivedDataWithRootObject(session!)
        defaults.setObject(sessionData, forKey: "SpotifySession")
        AudioPlayer.sharedInstance.session = session
        AudioPlayer.sharedInstance.player?.loginWithSession(session, callback: { (error) -> Void in
            println("player login error \(error)")
        })

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        appDelegate.currentUser = User(
        performSegueWithIdentifier("LoggedInSegue", sender: self)
    }
    
    func authenticationViewControllerDidCancelLogin(authenticationViewController: SPTAuthViewController!)
    {
        println("Log In Canceled")
    }
    
    
}

