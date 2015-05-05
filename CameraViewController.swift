//
//  CameraViewController.swift
//  MusicDiscovery
//
//  Created by Nick Martinson on 4/15/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class CameraViewController: PARViewController, PARControllerDelegate
{
    var radarThumbnailPosition:PARRadarPosition?
    var user:User?
    var users:[User]?
    
    /**********************************************************************************************************
    *   Initialize the nib view
    *********************************************************************************************************/
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**********************************************************************************************************
    *   Loads the PARView and sets the delegate
    *********************************************************************************************************/
    override func loadView()
    {
        super.loadView()
        PARController.sharedARController().delegate = self
        self.arRadarView.setRadarRange(100)
        self.cameraCaptureSession
    }
    
    /**********************************************************************************************************
    *
    *********************************************************************************************************/
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(true)
        PARController.deviceSupportsAR(true)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)
        PARPoiLabelTemplate.setAppearanceRange(50, andFarRange: 100)
        PoiSongLabelTemplate.setAppearanceRange(50, andFarRange: 100)
        user = (UIApplication.sharedApplication().delegate as! AppDelegate).currentUser
        BluemixCommunication().getNearbyUsers(user!.getUserID())
        {
            (users: [User]) in
            self.users = users
            self.createPOI()
        }
    }
    /**********************************************************************************************************
    *
    *********************************************************************************************************/
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.sensorManager().locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
 
    /**********************************************************************************************************
    *
    *********************************************************************************************************/
    override func usesCameraPreview() -> Bool {
        return true
    }
    
    /**********************************************************************************************************
    *
    *********************************************************************************************************/
    override func fadesInCameraPreview() -> Bool {
        return false
    }
    
    /**********************************************************************************************************
    *
    *********************************************************************************************************/
    override func rotatesARView() -> Bool {
        return true
    }
    
    
    /**********************************************************************************************************
    *   Hides the radar when the phone is tilted down. Shows the radar when the phone is upright.
    *********************************************************************************************************/
    override func switchFaceUp(inFaceUp: Bool)
    {
        if inFaceUp
        {
            if self.arRadarView != nil
            {
                self.arRadarView.setRadarToFullscreen(CGPointMake(0, 0), withSizeOffset: 120)
                self.arRadarView.hideRadar()
            }
        }
        else
        {
            if self.arRadarView != nil
            {
                self.arRadarView.showRadar()
                let rect = CGRectMake(0, 0, 0, 45)
                self.arRadarView.setRadarToThumbnail(PARRadarPositionBottomRight, withAdditionalOffset: rect)
            }
        }
    }

    
    
    /**********************************************************************************************************
    *
    *********************************************************************************************************/
    func arDidTapObject(object: PARObjectDelegate!)
    {
        println("Tapped on item")
    }
    
    
    func createPOI()
    {
//        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(5*Double(NSEC_PER_SEC)))
//        dispatch_after(delayTime, dispatch_get_main_queue()) { () -> Void in
//        println("Distance to user\n\(poiLabel.distanceToUser())")
        for user in users!
        {
            //create the poi label at the users location
            let poiLabel = PoiSongLabel(title: "", theDescription: "", theImage: UIImage(named: "Icon@2x~ipad"), fromTemplateXib: "PoiLabelWithImage", atLocation: user.getLocation())
            // check for real name
            if user.getRealName() != ""
            {
                poiLabel.poiTemplate?.userName.text = user.getRealName()
            }
            else
            {
                poiLabel.poiTemplate?.userName.text = user.getUserID()
            }
            // get profile pic if it exists
            if user.getImageURL() != nil
            {
                Alamofire.request(.GET, user.getImageURL()!, parameters: nil).responseImage { (_, _, image, error) -> Void in
                    if error == nil
                    {
                        poiLabel.poiTemplate?.profilePic.image = image
                    }
                }
            }
            // get album cover image
            if user.getCurrentSong() != nil
            {
                // place song information on the label
                poiLabel.poiTemplate?.songLabel.text = user.getSongName()
                poiLabel.poiTemplate?.artistLabel.text = user.getArtistName()
                poiLabel.poiTemplate?.songURI = user.getCurrentSong()
                SpotifyCommunication().getSongInfo(user.getCurrentSong()!)
                {
                    (album: SPTPartialAlbum) in
                    Alamofire.request(.GET, album.largestCover.imageURL, parameters: nil).responseImage { (_, _, image, error) -> Void in
                        if error == nil
                        {
                            poiLabel.poiTemplate?.image.image = image
                        }
                    }
                }
            }

            PARController.sharedARController().addObject(poiLabel)
        }
    }
    
}