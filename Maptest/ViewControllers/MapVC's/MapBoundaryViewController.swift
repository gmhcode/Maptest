//
//  MapBoundaryViewController.swift
//  Maptest
//
//  Created by Greg Hughes on 4/9/19.
//  Copyright © 2019 Greg Hughes. All rights reserved.
//

import UIKit
import MapKit

class MapBoundaryViewController: UIViewController {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    
    let geoCoder = CLGeocoder()
    
    var boundary: [CLLocationCoordinate2D] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationServices()
    }
}



extension MapBoundaryViewController: MKMapViewDelegate {
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolygonRenderer(overlay: overlay as! MKPolygon)
        renderer.strokeColor = .blue
        renderer.fillColor = UIColor.red.withAlphaComponent(0.5)
        
        return renderer
    }
    
    
}


// CRUD Boundaries

extension MapBoundaryViewController {
    
    @IBAction func createPointOfBoundary(_ sender: UITapGestureRecognizer) {
        
        
        let location = sender.location(in: self.mapView)
      
        let locationCoordinates = self.mapView.convert(location, toCoordinateFrom: self.mapView)
        boundary.append(locationCoordinates)
//        print("🌍\(locationCoordinates)")
        
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = locationCoordinates
//                print("🌸\(annotation.coordinate)")
        annotation.title = "New Place"
        annotation.subtitle = "subtitle"
        mapView.addAnnotation(annotation)
//        print("🐚\(boundary)")
    }
   
    
    
    @IBAction func deleteBoundary(_ sender: Any) {
        deleteBoundary()
    }
    
    func deleteBoundary(){
        boundary = []
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
    }
    
    @IBAction func makeBoundaryButtonTapped(_ sender: Any) {
        makeBoundary()
    }
    
    func makeBoundary(){
        mapView.addOverlay(MKPolygon(coordinates: boundary, count: boundary.count))
        
    }
}

extension MapBoundaryViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        makes the screen keep up with the user
        // guard against there being no location
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
extension MapBoundaryViewController {
    
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
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
//        previousLocation = getCenterLocation(for: mapView)
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
