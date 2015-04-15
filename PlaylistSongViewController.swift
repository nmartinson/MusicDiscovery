//
//  PlaylistSongViewController.swift
//  MusicDiscovery
//
//  Created by Nick Martinson on 4/14/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import UIKit

class PlaylistSongController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var songTableView: UITableView!
    var playlistURI:NSURL?
    var session:SPTSession?
    var songList:[SPTPlaylistTrack] = []
    var audioPlayer = AudioPlayer.sharedInstance
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
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
                self.songList = listpage.items as! [SPTPlaylistTrack]
            }
            self.songTableView.reloadData()
        })
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
        return cell
    }
}