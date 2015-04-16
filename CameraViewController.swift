//
//  CameraViewController.swift
//  MusicDiscovery
//
//  Created by Nick Martinson on 4/15/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import UIKit

class CameraViewController: PARViewController, PARControllerDelegate
{
    var radarThumbnailPosition:PARRadarPosition?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        super.loadView()
        PARController.sharedARController().delegate = self
        self.arRadarView.setRadarRange(1500)
        self.cameraCaptureSession
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(true)
        PARController.deviceSupportsAR(true)
        let rect = CGRectMake(0, 0, 0, 45)
        radarThumbnailPosition = PARRadarPositionBottomRight
        self.arRadarView.setRadarToThumbnail(radarThumbnailPosition!, withAdditionalOffset: rect)
        self.arRadarView.showRadar()
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.sensorManager().locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
 
    
    override func usesCameraPreview() -> Bool {
        return true
    }
    
    override func fadesInCameraPreview() -> Bool {
        return false
    }
    
    override func rotatesARView() -> Bool {
        return true
    }
    
    override func switchFaceUp(inFaceUp: Bool)
    {
        if inFaceUp
        {
            self.arRadarView.setRadarToFullscreen(CGPointMake(0, 0), withSizeOffset: 120)
        }
        else
        {
            let rect = CGRectMake(0, 0, 0, 45)
            radarThumbnailPosition = PARRadarPositionBottomRight
//            self.arRadarView.setRadarToThumbnail(radarThumbnailPosition!, withAdditionalOffset: rect)
        }
    }
    
    func arDidTapObject(object: PARObjectDelegate!)
    {
        
    }
    
}