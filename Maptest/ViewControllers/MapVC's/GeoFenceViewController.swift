//
//  GeoFenceViewController.swift
//  Maptest
//
//  Created by Greg Hughes on 4/9/19.
//  Copyright © 2019 Greg Hughes. All rights reserved.
//

import UIKit
import MapKit
class GeoFenceViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var previousLocation: CLLocation?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        
        //TO ADD A GEOFENCE, USE THE ADDFENCE FUNCTION
//        addFence(latitude: 45.783346498903946, longitude: -108.51460992442232, radius: 10000)
    }
    
}




//Adding geofence circle on screen
extension GeoFenceViewController {
    
    func addFence(latitude: CLLocationDegrees, longitude: CLLocationDegrees, radius: CLLocationDistance ){
        
        //1
        //create center point for region
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        //2
        //create region
        let region = CLCircularRegion(center: center, radius: radius, identifier: "openingRegion")
        //3
        //start monitoring
        locationManager.startMonitoring(for: region)
        //4
        //create graphical overlay
        let fence = MKCircle(center: center, radius: region.radius)
        //5 (optional)
        //remove existing overlays
        mapView.removeOverlays(mapView.overlays)
        //6
        //add overlay
        mapView.addOverlay(fence)
    }
    
    
    @IBAction func addCircle(_ sender: UITapGestureRecognizer) {
        print("ADD REGION")
        

        let touchLocation = sender.location(in: mapView)
        let coordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)


        //creates the actual geofence
        let region = CLCircularRegion(center: coordinate, radius: 50, identifier: "geoFence")

        //remove overlay because it keeps adding multiple when you hold this down
        locationManager.startMonitoring(for: region)
        //creates the graphical representation of the geofence
        let circle = MKCircle(center: coordinate, radius: region.radius)

        
        mapView.removeOverlays(mapView.overlays)
        mapView.addOverlay(circle)
    }
}


extension GeoFenceViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        centerViewOnUserLocation()
        mapView.showsUserLocation = true
        locationManager.stopUpdatingLocation()
        
    }
//    Entered region
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
       
        
        if region.identifier == "geoFence" {
            showAlert(title: "you entered the region", message: "Wow theres cool stuff in here!")
        }
    }
//    left region
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
        if region.identifier == "geoFence"{
            showAlert(title: "you left the region", message: "say bye bye")
        } else{
            return
        }
    }
    
    func showAlert(title: String, message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true)
    }
}

//Rendering Circle on screen
extension GeoFenceViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        guard let circleOverlay = overlay as? MKCircle else {print("🔥❇️>>>\(#file) \(#line): guard ket failed<<<"); return MKOverlayRenderer() }
        let circleRenderer = MKCircleRenderer(overlay: circleOverlay)
        
        circleRenderer.strokeColor = .red
        circleRenderer.fillColor = .red
        circleRenderer.alpha = 0.5
        
        return circleRenderer
    }
}

extension GeoFenceViewController {
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 10000, longitudinalMeters: 10000)
            
            mapView.setRegion(region, animated: true)
            
        }
    }
}



