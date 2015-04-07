//
//  AppDelegate.swift
//  SpotifyTest
//
//  Created by Nick Martinson on 4/1/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let kClientId = "9267f34373fa4cb1bf9ea94246a45566"
    let kCallbackURL = "musicdiscoverylogin://callback"
    var session:SPTSession?
    var player:SPTAudioStreamingController?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // configure the singleton default SPTAuth object with our clientId and callback URL
        SPTAuth.defaultInstance().clientID = kClientId
        SPTAuth.defaultInstance().redirectURL = NSURL(string: kCallbackURL)
        
        return true
    }
    
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool
    {
        println("OPEN URL")
        // check if the url is a valid spotify url
        if SPTAuth.defaultInstance().canHandleURL(url)
        {
            SPTAuth.defaultInstance().handleAuthCallbackWithTriggeredAuthURL(url, callback: { (error, session) -> Void in
                if error != nil { println("error \(error)") }
                else
                {
                    self.session = session
                    // request the current users information
                    SPTRequest.userInformationForUserInSession(session, callback: { (error, user) -> Void in
                        let name = user.displayName
                        println(name)
                    })
                }
                
                // store the session data in user defaults
                let defaults = NSUserDefaults.standardUserDefaults()
                let sessionData = NSKeyedArchiver.archivedDataWithRootObject(session!)
                defaults.setObject(sessionData, forKey: "SpotifySession")
//                self.playUsingSession(session)
            })
        }
        
        return false
    }
    
    
    
    
    
    
    // Test for playing a random song from an album URI i found
    func playUsingSession(session:SPTSession, request: NSURL)
    {
        // if the player is nil, initialize it with the clientID
        if self.player == nil { self.player = SPTAudioStreamingController(clientId: kClientId) }
        self.player?.loginWithSession(session, callback: { (error) -> Void in
            
            if error != nil { println("Playback error \(error)") }
            else
            {
                println("player login")
//                SPTRequest.requestItemAtURI(request, withSession: session, callback: { (error, album) -> Void in
//                    if error != nil
//                    {
//                        println("Album error")
//                    }
//                    else
//                    {
//                        var item = (album as SPTTrack).playableUri
//                        println(item)
                        self.player?.playURIs([request], fromIndex: 0, callback: { (error) -> Void in
                            if error != nil
                            {
                                println("Playback error \(error)")
                            }
                        })
//                    }
//                })
            }
        })
    }
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

