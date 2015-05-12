//
//  ViewController.swift
//  SpotifyTest
//
//  Created by Nick Martinson on 4/1/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, SPTAuthViewDelegate, LoginLocationNotificationProtocol
{
    let auth = SPTAuth.defaultInstance()
    
    let locHandler = LocationHandler.sharedInstance
    
    var userCreated = false
    
    var session: SPTSession!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        locHandler.loginLocNotDelegate = self
        notifyLocationHandler()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func locationIsReady() {
        if self.session != nil {
            createUser()
            self.userCreated = true
        }
    }
    
    func notifyLocationHandler () -> Void {
        locHandler.loginViewLoaded = true
    }
    
    
    func createUser() {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let lat = LocationHandler.sharedInstance.latitude
        let lon = LocationHandler.sharedInstance.longitude
        
        SPTRequest.userInformationForUserInSession(self.session, callback: { (error, user) -> Void in
            if error == nil
            {
                println("No error SPTRequest.userInformationForUserInSession:")
                
                let loggedUser = user as! SPTUser
                var profilePic = ""
                var realName = ""
                var userID = ""
                let product = (loggedUser.product as SPTProduct).hashValue
                println("product \(product.hashValue)")
                if product == 2 || product == 1
                {
                    AudioPlayer.sharedInstance.premium = true
                }
                else
                {
                    AudioPlayer.sharedInstance.premium = false
                }
                if loggedUser.largestImage != nil
                {
                    profilePic = "\(loggedUser.largestImage.imageURL)"
                }
                if loggedUser.displayName != nil
                {
                    realName = loggedUser.displayName
                }
                if loggedUser.canonicalUserName != nil
                {
                    userID = loggedUser.canonicalUserName
                }
                println(profilePic)
                println(realName)
                println(userID)
                println(lat)
                println(lon)
                
                appDelegate.currentUser = User(realName: realName, userID: userID, profilePicture: profilePic)
                AudioPlayer.sharedInstance.user = appDelegate.currentUser

                // check if the current user already has an account
                BluemixCommunication().getUserInfo(userID)
                {
                    (user: User?) in
                    
                    if user == nil
                    {
                        println("CREATING USER")
                        // if user doesn't exist, create an account
                        BluemixCommunication().createNewUser(userID, name: realName, lat: lat, lon: lon, profilePicture: profilePic)
                        {
                            // update user location
                            BluemixCommunication().updateLocation(userID, lat: lat, lon: lon)
                            self.locHandler.userID = userID
                        }
                    }
                    else
                    {
                        // UPDATE USER LOCATION
                        println("USER EXISTS")
                        BluemixCommunication().updateLocation(userID, lat: lat, lon: lon)
                        self.locHandler.userID = userID
                    }
                }
            } else {
                println("Error SPTRequest.userInformationForUserInSession:")
                println("\t\(error)")
            }
        })

        
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
                        AudioPlayer.sharedInstance.player?.loginWithSession(newSession, callback: { (error) -> Void in })
                    }
                })
            }
            else if session.isValid()
            {
                AudioPlayer.sharedInstance.player?.loginWithSession(session, callback: { (error) -> Void in })
                
                SPTRequest.userInformationForUserInSession(session, callback: { (error, user) -> Void in
                    if error == nil
                    {
                        let loggedUser = user as! SPTUser
                        var profilePic = ""
                        var realName = ""
                        var userID = ""
                        let product = (loggedUser.product as SPTProduct).hashValue
                        println("product \(product.hashValue)")
                        if product == 2 || product == 1
                        {
                            AudioPlayer.sharedInstance.premium = true
                        }
                        else
                        {
                            AudioPlayer.sharedInstance.premium = false
                        }
                        if loggedUser.largestImage != nil
                        {
                            profilePic = "\(loggedUser.largestImage.imageURL)"
                        }
                        if loggedUser.displayName != nil
                        {
                            realName = loggedUser.displayName
                        }
                        if loggedUser.canonicalUserName != nil
                        {
                            userID = loggedUser.canonicalUserName
                        }
                        println("USER ID \(userID), DISPLAY NAME \(realName)")
                        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        appDelegate.currentUser = User(realName: realName, userID: userID, profilePicture: profilePic)
                        AudioPlayer.sharedInstance.user = appDelegate.currentUser
                        // UPDATE CURRENT LOCATION
                        BluemixCommunication().updateLocation(userID, lat: LocationHandler.sharedInstance.latitude, lon: LocationHandler.sharedInstance.longitude)
                        self.locHandler.userID = userID
                        
                    }
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
            println("\nplayer login error \(error)")
        })
        
        self.session = session
        
        self.performSegueWithIdentifier("LoggedInSegue", sender: self)
        
    }
    
    func authenticationViewControllerDidCancelLogin(authenticationViewController: SPTAuthViewController!)
    {
        println("Log In Canceled")
    }
    
    
}

