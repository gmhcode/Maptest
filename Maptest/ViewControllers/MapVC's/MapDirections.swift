//
//  ViewController.swift
//  Maptest
//
//  Created by Greg Hughes on 4/9/19.
//  Copyright © 2019 Greg Hughes. All rights reserved.
//

import UIKit
import MapKit
import MessageUI
class MapDirections: UIViewController {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var goButton: UIButton!
    
    var searchedCoordinate = CLLocationCoordinate2D()
    let locationManager = CLLocationManager()
    var previousLocation: CLLocation?
    
    let geoCoder = CLGeocoder()
    
    var directionsArray: [MKDirections] = []
    var turnByTurnDirections = ""
    var deliveryDriverNumber = "8017225596"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        mapView.showsUserLocation = true
    }
    
    
    
    @IBAction func goButtonTapped(_ sender: UIButton) {
        getDirections {
            self.textDirections(message: self.turnByTurnDirections)
        }
    }
    
    
    func printDirections(){
//        PrintJobController.shared.addPrintJob(printer: <# Printer #>, textInput: turnByTurnDirections)
        
    }
    
    func textDirections(message: String){
        TwilioController.shared.sendText(message: message, to: deliveryDriverNumber) {
            
        }
    }
}



//Getting Directions
extension MapDirections {
    
    
    func getDirections(completion: @escaping ()->()) {
        
        turnByTurnDirections = ""
//        TwilioController.shared.message = ""
        
        guard let location = locationManager.location?.coordinate else {
            //TODO: Inform user we don't have their current location
            return
        }
        
        let request = createDirectionsRequest(from: location)
        let directions = MKDirections(request: request)
        
        resetMapView(withNew: directions)
        
        directions.calculate { [unowned self] (response, error) in
            //TODO: Handle error if needed
            guard let response = response else { return } //TODO: Show response not available in an alert
            
            for route in response.routes {
                
                for step in route.steps{
                    
                    print("🌹\(step.instructions)")
                    self.turnByTurnDirections.append("\(step.instructions) \n \n")
                    print("🍑\(self.turnByTurnDirections)")
//                    TwilioController.shared.message.append(" \(step.instructions) \n \n")
                }
                
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
            completion()
        }
        
    }
    
    func createDirectionsRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request {
        let startingLocation            = MKPlacemark(coordinate: coordinate)
        let destination                 = MKPlacemark(coordinate: searchedCoordinate)
        
        let request                     = MKDirections.Request()
        request.source                  = MKMapItem(placemark: startingLocation)
        request.destination             = MKMapItem(placemark: destination)
        request.transportType           = .automobile
        request.requestsAlternateRoutes = true
        
        return request
    }
    
    
    func resetMapView(withNew directions: MKDirections) {
        mapView.removeOverlays(mapView.overlays)
        directionsArray.append(directions)
        let _ = directionsArray.map { $0.cancel() }
    }
}




// rendering, changing regions
extension MapDirections: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let destination = CLLocation(latitude: searchedCoordinate.latitude, longitude: searchedCoordinate.longitude)
        
        geoCoder.reverseGeocodeLocation(destination) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let _ = error {
                //TODO: Show alert informing the user
                return
            }
            
            guard let placemark = placemarks?.first else {
                //TODO: Show alert informing the user
                return
            }
            
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
            
            DispatchQueue.main.async {
                self.addressLabel.text = "\(streetNumber) \(streetName)"
            }
        }
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .blue
        
        return renderer
    }
}




extension MapDirections: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
//        // guard against there being no location
//        guard let location = locations.last else {print("🔥❇️>>>\(#file) \(#line): guard ket failed<<<"); return  }
//        
//        //getting the lattitude and longitude of the users last known location
//        let lastKnownLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        
//        //the region will be the area in a 10,000 meter radius around the lastKnownLocation
//        let region = MKCoordinateRegion.init(center: lastKnownLocation, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
//        
//        //sets a new region when the user moves
//        mapView.setRegion(region, animated: true)
    }
}


//MARK: MAP SET UP
//Setting Up Location Authorization
extension MapDirections {
    
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 10000, longitudinalMeters: 10000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkAuth(){
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways{
            
        }
    }
    
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            startTackingUserLocation()
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            startTackingUserLocation()
            break
        @unknown default:
            break
        }
    }
    
    
    func startTackingUserLocation() {
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: mapView)
    }

    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
}


