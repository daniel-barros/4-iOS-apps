//
//  MapAnnotation.swift
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

import Foundation
import MapKit

/// Simple class that conforms to MKAnnotation protocol
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