//
//  ViewController.swift
//  appGPSQR
//
//  Created by Daniel Barros López on 2/8/16.
//  Copyright © 2016 Daniel Barros & Yoji Sargent. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController {
    
    let qrCodeReaderViewController = QRCodeReaderViewController(metadataObjectTypes: [AVMetadataObjectTypeQRCode])
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var directionsButton: UIButton!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    
    var targetLocations = [CLLocation]()
    var visitedLocations = [CLLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Closure executed when QR reader reads/cancels
        qrCodeReaderViewController.setCompletionWithBlock { (result: String?) in
            self.dismissViewControllerAnimated(true, completion: nil)
            if let string = result, location = CLLocation(stringFromQRCode: string) {
                self.cleanCurrentMapRoute()
                self.addNewTargetLocation(location)
            }
        }
        
        mapView.userTrackingMode = .Follow
        
        // Ask for location tracking authorization
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() != .AuthorizedAlways {
            locationManager.requestAlwaysAuthorization()
        } else {
            mapView.showsUserLocation = true
        }
        
        locationManager.distanceFilter = 5
        locationManager.startUpdatingLocation()
    }
    
    deinit {
        locationManager.stopUpdatingLocation()
    }
    
    @IBAction func scanQRCode(sender: AnyObject) {
        presentViewController(qrCodeReaderViewController, animated: true, completion: nil)
    }
    
    @IBAction func showTrail(sender: AnyObject) {
        
        cleanCurrentMapRoute()

        if finishButton.titleLabel == "Reiniciar" {
            finishButton.setTitle("Finalizar", forState: .Normal)
            locationManager.startUpdatingLocation()
        }
        
        let coordinates = visitedLocations.map { $0.coordinate }
        let coordinatesPointer = UnsafeMutablePointer<CLLocationCoordinate2D>(coordinates)
        let polyLine = MKPolyline(coordinates: coordinatesPointer, count: visitedLocations.count)
        mapView.addOverlay(polyLine, level: .AboveRoads)
        
        let annotations = targetLocations.map { MapAnnotation(location: $0) }
        mapView.addAnnotations(annotations)
        
        visitedLocations.removeAll()
        targetLocations.removeAll()
        
        finishButton.setTitle("Reiniciar", forState: .Normal)
        directionsButton.enabled = false
        locationManager.stopUpdatingLocation()
    }
    
    @IBAction func startDirections(sender: AnyObject) {
        let location = targetLocations.last!
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate, addressDictionary: nil))
        mapItem.openInMapsWithLaunchOptions([MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
    }
    
    func addNewTargetLocation(location: CLLocation) {
        targetLocations.append(location)
        mapView.addAnnotation(MapAnnotation(location: location))
        showRouteTo(location)
        directionsButton.enabled = true
    }
    
    func cleanCurrentMapRoute() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
    }
    
    /// Requests directions from current location to the specified location and draws a route on the map
    func showRouteTo(location: CLLocation) {
        let request = MKDirectionsRequest()
        request.source = MKMapItem.mapItemForCurrentLocation()
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate, addressDictionary: nil))
        request.requestsAlternateRoutes = false
        request.transportType = .Walking
        
        let directions = MKDirections(request: request)
        directions.calculateDirectionsWithCompletionHandler { [weak self] response, error in
            if let route = response?.routes.first {
                self?.mapView.addOverlay(route.polyline, level: .AboveRoads)
            }
        }
    }
}


// MARK: CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways {
            mapView.showsUserLocation = true
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        visitedLocations += locations
        finishButton.enabled = true
    }
}


// MARK: MKMapViewDelegate

extension ViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        let color = UIColor(red: 0.12, green: 0.56, blue: 1, alpha: 0.8)
        renderer.strokeColor = color
        renderer.lineWidth = 5
        return renderer
    }
}

// MARK:

private extension CLLocation {
    /// Initializes from a string like this "LATITUD_37.197269_LONGITUD_-3.624392"
    convenience init?(stringFromQRCode string: String) {
        let components = string.componentsSeparatedByString("_")
        guard components.count == 4 else {
            print("String from QR code has wrong format")
            return nil
        }
        if let lat = Double(components[1]), lon = Double(components[3]) {
            self.init(latitude: lat, longitude: lon)
        } else {
            return nil
        }
    }
}
