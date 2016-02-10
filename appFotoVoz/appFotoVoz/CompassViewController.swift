//
//  CompassViewController.swift
//  appFotoVoz
//
//  Created by Daniel Barros López and Yoji Sargent Harada
//  Last modification on Feb 6 2016
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

/// Handles a view containing a compass image that rotates along with the device, a label that shows the target orientation, and a needle whose color changes when facing it
class CompassViewController: UIViewController, CLLocationManagerDelegate {

    var orientation: Orientation!
    var locationManager = CLLocationManager()
    @IBOutlet weak var compassImageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var needleView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = orientation.description
        locationManager.delegate = self
        locationManager.startUpdatingHeading()
    }
    
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let degrees = newHeading.magneticHeading
        let radians = degrees * M_PI / 180.0
        
        // rotates compass image
        UIView.animateWithDuration(0.2) {
            self.compassImageView.transform = CGAffineTransformMakeRotation(CGFloat(-radians))
        }
        
        // updates the needle color if pointing to the proper orientation
        if orientation.containsAngle(degrees) {
            UIView.animateWithDuration(0.2) {
                self.needleView.backgroundColor = UIColor.greenColor()
            }
        } else if needleView.backgroundColor != UIColor.redColor() {
            UIView.animateWithDuration(0.2) {
                self.needleView.backgroundColor = UIColor.redColor()
            }
        }
    }

}
