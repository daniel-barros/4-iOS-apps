//
//  MapAnnotation.swift
//  appGPSQR
//
//  Created by Daniel Barros López on 2/8/16.
//  Copyright © 2016 Daniel Barros & Yoji Sargent. All rights reserved.
//

import Foundation
import MapKit

class MapAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    
    init(location: CLLocation) {
        coordinate = location.coordinate
        super.init()
    }
    
    init(locationCoordinate: CLLocationCoordinate2D) {
        coordinate = locationCoordinate
        super.init()
    }
}