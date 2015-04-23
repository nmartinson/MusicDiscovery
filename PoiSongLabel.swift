//
//  PoiSongLabel.swift
//  MusicDiscovery
//
//  Created by Nick Martinson on 4/21/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import UIKit

class PoiSongLabel: PARPoiLabel
{
    var poiTemplate:PoiSongLabelTemplate?
    
    
    override init!(title theTitle: String!, theDescription: String!, theImage: UIImage!, fromTemplateXib theTemplateXib: String!, atLocation theLocation: CLLocation!) {
        super.init(title: theTitle, theDescription: theDescription, theImage: theImage, fromTemplateXib: theTemplateXib, atLocation: theLocation)
        awakeFromNib()
    }
    
        override func awakeFromNib()
        {
            println("awake")
            poiTemplate = NSBundle.mainBundle().loadNibNamed("PoiLabelSong", owner: self, options: nil).first as? PoiSongLabelTemplate
            poiTemplate!.songLabel.text = "HEEEEEY"
            super.labelView = poiTemplate
        }
}