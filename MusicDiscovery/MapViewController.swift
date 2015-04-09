


import UIKit

private let _MapVCSharedInstance = MapViewController()

class MapViewController: UIViewController {
    
    let locHandler = LocationHandler.sharedInstance
    
    @IBOutlet weak var mapView: GMSMapView!
    
    class var sharedInstance: MapViewController {
        return _MapVCSharedInstance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //mapView = MapHandler.sharedInstance
  }
    
    
    func updateMap() {
        println("Updating map")
        mapView.myLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        
        mapView.camera = GMSCameraPosition(target: locHandler.location2D, zoom: 30, bearing: 0, viewingAngle: 0)
        mapView.mapType = kGMSTypeNormal
    }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

  }

}

