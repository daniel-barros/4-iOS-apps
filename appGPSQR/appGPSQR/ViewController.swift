//
//  ViewController.swift
//  appGPSQR
//
//  Created by Daniel Barros López and Yoji Sargent Harada
//  Last modification on Feb 13 2016
//
//  Copyright (C) 2015  Yoji Sargent Harada, Daniel Barros López
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

import UIKit
import CoreLocation
import MapKit

// Handles a view containing a map view, a finish button, scan button and directions button.
// When pressing the scan button a QR code reader will show up. Then, if a proper location is retrieved, a route from the current location to that one is shown on the map.
// It records user location over time since app starts.
// Pressing the finish button will show the recorded sequence of locations (as a route) and all the scanned locations.
// Pressing the directions button will open the Maps app and start step by step walking directions to the last scanned location
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
            // Gets string and tries to initialize location from it
            if let string = result, location = CLLocation(stringFromQRCode: string) {
                self.cleanCurrentMapRoute()
                self.addNewTargetLocation(location)
            }
        }
        
        mapView.userTrackingMode = .Follow
        locationManager.distanceFilter = 5
        
        // Ask for location tracking authorization and start getting location updates
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() != .AuthorizedAlways {
            locationManager.requestAlwaysAuthorization()
        } else {
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        }
    }
    
    deinit {
        locationManager.stopUpdatingLocation()
    }
    
    @IBAction func scanQRCode(sender: AnyObject) {
        presentViewController(qrCodeReaderViewController, animated: true, completion: nil)
    }
    
    /// Shows the sequence of visited locations and all the scanned locations
    @IBAction func showTrail(sender: AnyObject) {
        
        cleanCurrentMapRoute()

        // Restart
        if finishButton.titleForState(.Normal) == "Reiniciar" {
            finishButton.setTitle("Finalizar", forState: .Normal)
            scanButton.enabled = true
            locationManager.startUpdatingLocation()
            return
        }
        
        // Visited locations route to map
        let coordinates = visitedLocations.map { $0.coordinate }
        let coordinatesPointer = UnsafeMutablePointer<CLLocationCoordinate2D>(coordinates)
        let polyLine = MKPolyline(coordinates: coordinatesPointer, count: visitedLocations.count)
        mapView.addOverlay(polyLine, level: .AboveRoads)
        
        // Scanned locations to map
        let annotations = targetLocations.map { MapAnnotation(location: $0) }
        mapView.addAnnotations(annotations)
        
        // Cleanup
        visitedLocations.removeAll()
        targetLocations.removeAll()
        
        finishButton.setTitle("Reiniciar", forState: .Normal)
        directionsButton.enabled = false
        scanButton.enabled = false
        directionsButton.tintColor = UIColor.lightGrayColor()
        locationManager.stopUpdatingLocation()
    }
    
    /// Opens the Maps app and starts step by step walking directions to the last scanned location
    @IBAction func startDirections(sender: AnyObject) {
        let location = targetLocations.last!
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate, addressDictionary: nil))
        mapItem.openInMapsWithLaunchOptions([MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
    }
    
    /// Shows location on map and route from current location to that location
    func addNewTargetLocation(location: CLLocation) {
        targetLocations.append(location)
        mapView.addAnnotation(MapAnnotation(location: location))
        showRouteTo(location)
        directionsButton.enabled = true
        directionsButton.tintColor = self.view.tintColor
    }
    
    /// Removes all map annotations and overlays
    func cleanCurrentMapRoute() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
    }
    
    /// Requests directions from current location to the specified location and draws a route on the map
    func showRouteTo(location: CLLocation) {
        // Request setup
        let request = MKDirectionsRequest()
        request.source = MKMapItem.mapItemForCurrentLocation()
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate, addressDictionary: nil))
        request.requestsAlternateRoutes = false
        request.transportType = .Walking
        
        // Computing directions
        let directions = MKDirections(request: request)
        directions.calculateDirectionsWithCompletionHandler { [weak self] response, error in
            if let route = response?.routes.first {     // There should be only one route
                self?.mapView.addOverlay(route.polyline, level: .AboveRoads)
            }
        }
    }
}


// MARK: CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        // Starts getting location updates if authorized
        if status == .AuthorizedAlways {
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Only saves locations with a minimum accuracy
        visitedLocations += locations.filter { $0.horizontalAccuracy < 35 }
        finishButton.enabled = true
    }
}


// MARK: MKMapViewDelegate

extension ViewController: MKMapViewDelegate {
    
    // (Tells map view how to draw overlays)
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        let color = UIColor(red: 0.12, green: 0.56, blue: 1, alpha: 0.8)
        renderer.strokeColor = color
        renderer.lineWidth = 5
        return renderer
    }
}

// MARK: -

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
