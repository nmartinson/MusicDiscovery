//
//  PoiSongLabelTemplate.swift
//  MusicDiscovery
//
//  Created by Nick Martinson on 4/21/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import UIKit

class PoiSongLabelTemplate: PARPoiLabelTemplate
{
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    var songURI:NSURL?
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func labelTapped(sender: UIButton)
    {
//        println("LABEL TOUCHED")
    }
    
    @IBAction func playButtonTapped(sender: UIButton)
    {
        if songURI != nil
        {
            AudioPlayer.sharedInstance.playUsingSession(songURI!)
        }
    }
}