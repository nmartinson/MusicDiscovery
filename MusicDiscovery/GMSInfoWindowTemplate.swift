//
//  GMSInfoWindowTemplate.swift
//  MusicDiscovery
//
//  Created by Dillon McCusker on 4/26/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation

class GMSInfoWindowTemplate: UIView {
    
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var albumCover: UIImageView!
    
    @IBOutlet weak var songLabel: UILabel!
    
    
    @IBAction func playButtonTapped(sender: UIButton) {
        //play song
        println("Tapped Play Button!!!")
    }
}