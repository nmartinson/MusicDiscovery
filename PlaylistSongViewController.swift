//
//  PlaylistSongViewController.swift
//  MusicDiscovery
//
//  Created by Nick Martinson on 4/14/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import UIKit

class PlaylistSongController: UIViewController, UITableViewDelegate, UITableViewDataSource, AudioPlayerDelegate
{
    @IBOutlet weak var songTableView: UITableView!
    var playlistURI:NSURL?
    var session:SPTSession?
    var songList:[SPTPlaylistTrack] = []
    var audioPlayer = AudioPlayer.sharedInstance
    var playlistName:String?
    let backgroundImage = UIImageView(image: UIImage(named: "audiowave2"))

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        audioPlayer.delegate = self
        navigationItem.title = playlistName
        backgroundImage.contentMode = .ScaleAspectFill
        backgroundImage.alpha = 0.5
        songTableView.backgroundView = backgroundImage
        
        // gets a hold of the session object
        if let sessionObj:AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("SpotifySession")
        {
            // convert the stored session object back to SPTSession
            let sessionData = sessionObj as! NSData
            session = NSKeyedUnarchiver.unarchiveObjectWithData(sessionData) as? SPTSession
        }
        
        // Request the songs for the current playlist
        SPTPlaylistSnapshot.playlistWithURI(playlistURI, session: self.session, callback: { (error, playlist) -> Void in
            if error != nil { println("Playlist request error") }
            else
            {
                let listpage = (playlist as! SPTPlaylistSnapshot).firstTrackPage
                if listpage.items != nil
                {
                    self.songList = listpage.items as! [SPTPlaylistTrack]
                    self.songTableView.reloadData()
                }
            }
        })
    }
    
    func notAPremiumUser()
    {
        let alertController = UIAlertController(
            title: "Sorry!",
            message: "You must have a Spotify premium account to play music.",
            preferredStyle: .Alert
        )
        let cancelAction = UIAlertAction(title: "Okay", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    /******************************************************************************************************
    *   Plays the selected song
    ******************************************************************************************************/
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let URL = songList[indexPath.row].playableUri

        audioPlayer.playUsingSession(URL)
    }

    /******************************************************************************************************
    *
    ******************************************************************************************************/
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return songList.count
    }
    
    /******************************************************************************************************
    *   Puts the song and artist name in the cell
    ******************************************************************************************************/
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("songCell") as! UITableViewCell
        cell.textLabel?.text = songList[indexPath.row].name
        cell.detailTextLabel?.text = songList[indexPath.row].artists.first?.name
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.detailTextLabel?.textColor = UIColor.whiteColor()

        return cell
    }
}