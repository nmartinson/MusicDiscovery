//
//  ProfileViewController.swift
//  MusicDiscovery
//
//  Created by Nick Martinson on 4/8/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

/******************************************************************************************
*
******************************************************************************************/
extension Alamofire.Request
{
    class func imageResponseSerializer() -> Serializer{
        return { request, response, data in
            if( data == nil) {
                return (nil,nil)
            }
            let image = UIImage(data: data!, scale: UIScreen.mainScreen().scale)
            
            return (image, nil)
        }
    }
    
    func responseImage(completionHandler: (NSURLRequest, NSHTTPURLResponse?, UIImage?, NSError?) -> Void) -> Self{
        return response(serializer: Request.imageResponseSerializer(), completionHandler: { (request, response, image, error) in
            completionHandler(request, response, image as? UIImage, error)
        })
    }
}


class ProfileViewController: UIViewController
{
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad()
    {
        // get the session object
        let sessionObj:AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("SpotifySession")!
        let sessionData = sessionObj as! NSData
        let session = NSKeyedUnarchiver.unarchiveObjectWithData(sessionData) as! SPTSession
        
        // request the current users information
        SPTRequest.userInformationForUserInSession(session, callback: { (error, user) -> Void in
            self.nameLabel.text = user.displayName
            println("ID \(user.canonicalUserName)")
            if let image = (user as! SPTUser).largestImage
            {
                Alamofire.request(.GET, image.imageURL, parameters: nil).responseImage({ (request, _, image, error) -> Void in
                    if error == nil && image != nil
                    {
                        self.profilePicture.image = image
                        //                    completion(result: image!)
                    }
                })
            }
            
        })
    }
    
    @IBAction func doneButtonPressed(sender: UIBarButtonItem)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}