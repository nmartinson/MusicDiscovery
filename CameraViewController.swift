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
        self.arRadarView.setRadarRange(200)
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
        createARPoiObjects()
        user = (UIApplication.sharedApplication().delegate as! AppDelegate).currentUser
        BluemixCommunication().getNearbyUsers(user!.getUserID())
        {
            (users: [User]) in
            self.users = users
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
        for user in users!
        {
            let poiLabel = PoiSongLabel(title: "", theDescription: "", theImage: UIImage(named: "Icon@2x~ipad"), fromTemplateXib: "PoiLabelWithImage", atLocation: user.getLocation())
            if user.getRealName() != ""
            {
                poiLabel.poiTemplate?.userName.text = user.getRealName()
            }
            else
            {
                poiLabel.poiTemplate?.userName.text = user.getUserID()
            }
        }
    }
    
    
    /**********************************************************************************************************
    *
    *********************************************************************************************************/
    func createARPoiObjects()
    {
        let poiLabel = PARPoiLabel(title: "Dom", theDescription: "Regensburger Dom", theImage: UIImage(named: "Icon@2x~ipad"), fromTemplateXib: "PoiLabelWithImage", atLocation: CLLocation(latitude: 49.019512, longitude:  12.097709))
        poiLabel.image = UIImage(named: "machu")
        
        
        
        let user = (UIApplication.sharedApplication().delegate as! AppDelegate).currentUser
        let poiSong = PoiSongLabel(title: "Test", theDescription: "hello", theImage: UIImage(named: "Icon@2x~ipad"), fromTemplateXib: "PoiLabelSong", atLocation: CLLocation(latitude: 41.661100, longitude:  -91.536104))
        poiSong.poiTemplate?.userName.text = user?.getRealName()
        
        if AudioPlayer.sharedInstance.player.currentTrackURI != nil
        {
            SpotifyCommunication().getSongInfo(AudioPlayer.sharedInstance.player.currentTrackURI)
                {
                    (album: SPTPartialAlbum) in
                    Alamofire.request(.GET, album.largestCover.imageURL, parameters: nil).responseImage { (_, _, image, error) -> Void in
                        if error == nil
                        {
                            poiSong.poiTemplate?.image.image = image
                        }
                    }
            }
        }
        
        if user?.getImageURL() != nil
        {
            Alamofire.request(.GET, user!.getImageURL()!, parameters: nil).responseImage { (_, _, image, error) -> Void in
                if error == nil
                {
                    poiSong.poiTemplate?.profilePic.image = image
                }
            }
        }
        
        
        let dillonPoi = PoiSongLabel(title: "Tet", theDescription: "", theImage: UIImage(named: "Icon@2x~ipad"), fromTemplateXib: "PoiLabelSong", atLocation: CLLocation(latitude: 41.659410, longitude:  -91.536166))
        dillonPoi.poiTemplate?.userName.text = "Dillon McCusker"
        dillonPoi.poiTemplate?.songLabel.text = "I'm a Barbie Girl"
        dillonPoi.poiTemplate?.artistLabel.text = "Aqua"
        Alamofire.request(.GET, "http://upload.wikimedia.org/wikipedia/en/thumb/6/6b/Aquariumcover1.jpg/220px-Aquariumcover1.jpg", parameters: nil).responseImage { (_, _, image, error) -> Void in
            if error == nil
            {
                dillonPoi.poiTemplate?.image.image = image
            }
        }
        
        PARController.sharedARController().addObject(poiLabel)
        PARController.sharedARController().addObject(poiSong)
        PARController.sharedARController().addObject(dillonPoi)
    }
    
    
    
    
}