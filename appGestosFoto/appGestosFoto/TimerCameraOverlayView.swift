//
//  TimeCameraOverlayView.swift
//  appGestosFoto
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

// A custom view containing a label
class TimerCameraOverlayView: UIView {
    
    var label = UILabel()
    
    // Updates the label's text simulating a 3 second timer
    func start3secTimer() {
        label.text = "3"
        label.sizeToFit()
        delay(1) {
            self.label.text = "2"
        }
        delay(2) {
            self.label.text = "1"
        }
        delay(3) {
            self.label.text = "0"
        }
    }

    init() {
        super.init(frame: CGRect(x: UIScreen.mainScreen().bounds.width/2 - 8,
            y: UIScreen.mainScreen().bounds.height - 100,
            width: 80, height: 80))
        
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.systemFontOfSize(40, weight: UIFontWeightMedium)
        label.sizeToFit()
        addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
