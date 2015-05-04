import UIKit

class MapViewController: UIViewController, MapUpdateProtocol, MapLocationNotificationProtocol, GMSMapViewDelegate {
    
    let locHandler = LocationHandler.sharedInstance

    @IBOutlet weak var mapView: GMSMapView!
    
    var mapSetup: Bool = false
    
    let calculator = MapCalculator()
    
    var currentMapType: GMSMapViewType = kGMSTypeNormal
    
    var mapTimer: NSTimer!
    var markerTimer: NSTimer!
    
    var conicPolygon = GMSPolygon()
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var id: String!
    
    var shouldGetUsers = true
    
    var usersArr: [User]!
    var userMarkerArr: [GMSMarker]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mapView.delegate = self
        
        locHandler.mapLocNotDelegate = self
        locHandler.mapUpdateDelgate = self
        
        mapTimerInit()
        markerTimerInit()
    }
    
    override func viewDidAppear(animated: Bool) {
        mapView.myLocationEnabled = true
        
        notifyLocationHandler()
        
        id = appDelegate.currentUser?.getUserID()
        requestNearbyUsers()
        
        mapTimerInit()
        markerTimerInit()
    }
    
    override func viewWillDisappear(animated: Bool) {
        mapTimerKill()
        markerTimerKill()
    }
    
    func notifyLocationHandler () -> Void {
        locHandler.mapViewExists = true
    }
    
    func checkMapExistence() -> Bool {
        if mapView != nil {
            return true
        }
        return false
    }
    
    
    func mapTimerInit() -> Void {
        self.mapTimer = NSTimer(timeInterval: 0.1, target: self, selector: Selector("mapTimerDidFire"), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(self.mapTimer, forMode: NSRunLoopCommonModes)
    }
    
    func mapTimerDidFire() -> Void {
        println("map timer fired")
        
        var mapSuccess = false
        
        if !self.mapSetup {
            setMapLocation()
            if self.mapSetup {
                mapSuccess = true
            } else {
                mapSuccess = false
            }
        } else {
            mapSuccess = true
        }
        
        if mapSuccess {
            mapTimerKill()
        }
    }
    
    func mapTimerKill() -> Void {
        if self.mapTimer != nil {
            self.mapTimer.invalidate()
        }
    }
    
    func markerTimerInit() -> Void {
//        self.markerTimer = NSTimer(timeInterval: 10, target: self, selector: Selector("markerTimerDidFire"), userInfo: nil, repeats: true)
//        NSRunLoop.currentRunLoop().addTimer(self.markerTimer, forMode: NSRunLoopCommonModes)
    }
    
    func markerTimerDidFire() -> Void {
        println("marker timer fired")
        
        if requestNearbyUsers() {
            println("Retrieved users")
        } else {
            println("failed to retrieve users")
        }
    }
    
    func markerTimerKill() -> Void {
        if self.markerTimer != nil {
            self.markerTimer.invalidate()
        }
    }
    
    func requestNearbyUsers() -> Bool {
        id = appDelegate.currentUser?.getUserID()
        
        if id != nil{
            BluemixCommunication().getNearbyUsers(id!, completion: { (users) -> Void in
                println("users:")
                println("\t\(users)")
                if !users.isEmpty {
                    self.markUsersOnMap(users)
                }
            })
            return true
        }
        println("")
        return false
    }
    
    func markUsersOnMap(usersArr: [User]) {
        
        if userMarkerArr == nil {   //initialize arr if nil
            
            userMarkerArr = [GMSMarker]()
            
        } else {
            for index in 0..<userMarkerArr.count { //loop through array, remove map markers
                
                userMarkerArr[index].map = nil
            }
            while !userMarkerArr.isEmpty { //empty the array
                userMarkerArr.removeLast()
            }
        }
        
        for index in 0..<usersArr.count {
            var position = CLLocationCoordinate2DMake( usersArr[index].getLocation2D()["latitude"]!.doubleValue , usersArr[index].getLocation2D()["longitude"]!.doubleValue )
            var userMarker = GMSMarker(position: position)

            userMarker.userData = usersArr[index]
            userMarker.map = self.mapView
        }
    }
    
//    func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
//        println("Tapped marker")
//        return false
//    }
    
    func mapView(mapView: GMSMapView!, markerInfoWindow marker: GMSMarker!) -> UIView! {
        println("Custom InfoWindow function")
        
        var infoWindow = NSBundle.mainBundle().loadNibNamed("GMSInfoWindow", owner: self, options: nil).first! as! GMSInfoWindowTemplate
        
        var user:User! = marker.userData as! User!
        
        if user != nil {
            infoWindow.profilePic = UIImageView(image: user.getProfilePicture() )
//            infoWindow.userName.text = user.getRealName()
            infoWindow.userName.text = user.getUserID()
//            infoWindow.albumCover = user.
            infoWindow.songLabel.text = user.getSongName()
        }
        return infoWindow
    }
    
    func mapView(mapView: GMSMapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        updateMapViewToLocation()
    }
    
    func updateMapViewToCamera () -> Void {
        if locHandler.location2D != nil && locHandler.bearing != nil {
            var updateBearing = locHandler.bearing.trueHeading
            var location2D = locHandler.location2D
            var mapZoom = self.mapView.camera.zoom

            mapView.camera = GMSCameraPosition(target: location2D, zoom: mapZoom, bearing: updateBearing, viewingAngle: 0)

            drawCone()
        }
    }
    
    func updateMapViewToBearing () -> Void {

        if locHandler.bearing != nil {
            var updateBearing = locHandler.bearing.trueHeading
            self.mapView.animateToBearing(updateBearing)
            drawCone()
        }
    }

    func updateMapViewToLocation () -> Void {
        
        if locHandler.location2D != nil {
            var updateLocation = locHandler.location2D
            self.mapView.animateToLocation(updateLocation)
            drawCone()
        }
    }
    
    func setMapLocation () -> Void {
        
        if mapView != nil {
            if locHandler.location2D != nil {
                var initBearing:CLLocationDirection = 0
                if locHandler.bearing != nil {
                    initBearing = locHandler.bearing.trueHeading
                }
                var mapInsets = UIEdgeInsetsMake(450.0, 0.0, 0.0, 0.0)
                mapView.padding = mapInsets
                
                mapView.camera = GMSCameraPosition(target: locHandler.location2D, zoom: 15.5, bearing: initBearing, viewingAngle: 0)
                mapView.mapType = currentMapType
                mapView.settings.scrollGestures = false
                mapView.settings.zoomGestures = false
                
                //stop the timer now that the map is setup
                mapTimerKill()
                self.mapSetup = true
            }
        }
    }
    
    func drawCone() -> Void {
        
        var points2D:[CLLocationCoordinate2D] = calculator.calculateForwardPoints()
        
        var conicPath = GMSMutablePath()
        for point in points2D {
            conicPath.addCoordinate(point)
        }
        
        conicPolygon.map = nil
        conicPolygon = GMSPolygon(path: conicPath)
        conicPolygon.fillColor = UIColor(red: 0.235, green: 0.0, blue: 0.255, alpha:0.30)
        conicPolygon.strokeColor = UIColor.blackColor()
        conicPolygon.strokeWidth = 2
        conicPolygon.map = mapView
    }
    
    //this is only a test function
    func drawLine () -> Void {
        var path = GMSMutablePath()
        path.addCoordinate(locHandler.location2D)
    //    path.addCoordinate(calculator.calculateForwardPoint())
        
        var line = GMSPolyline(path: path)
        line.strokeColor = UIColor.blackColor()
        line.strokeWidth = 2
        line.map = self.mapView
    }
    
    //This is only a test function
    func drawPolygon () -> Void {
        // Create a rectangular path
        var rect = GMSMutablePath()
        rect.addCoordinate(CLLocationCoordinate2DMake(37.36, -122.0))
        rect.addCoordinate(CLLocationCoordinate2DMake(37.45, -122.0))
        rect.addCoordinate(CLLocationCoordinate2DMake(37.45, -122.2))
        rect.addCoordinate(CLLocationCoordinate2DMake(37.36, -122.2))
        
        // Create the polygon, and assign it to the map.
        var polygon = GMSPolygon(path: rect)
        polygon.fillColor = UIColor(red:0.25, green:0, blue:0, alpha:0.05)
        polygon.strokeColor = UIColor.blackColor()
        polygon.strokeWidth = 2
        polygon.map = mapView
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }

}

