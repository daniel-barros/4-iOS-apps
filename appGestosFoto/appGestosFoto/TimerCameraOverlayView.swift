//
//  TimeCameraOverlayView.swift
//  appGestosFoto
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

// A custom view containing a label
class TimerCameraOverlayView: UIView {
    
    var label: UILabel
    var button: UIButton
    weak var delegate: TimerCameraOverlayViewDelegate?
    
    private var started = false
    
    /// Starts a timer that will fire in the specified time (in seconds) notifying the delegate.
    /// - warning: Use only for short timers. Not efficiently implemented for cases with long timers where user restarts timer after canceling several times
    func startTimer(seconds: Int) {
        started = true
        label.text = String(seconds)
        label.sizeToFit()
        decreaseTime(seconds - 1)
    }
    
    /// Recursively decrements timer
    private func decreaseTime(remainingSecs: Int) {
        delay(1) { [weak self] in
            if let strongSelf = self where strongSelf.started {
                strongSelf.label.text = String(remainingSecs)   // updates label
                if remainingSecs == 0 {
                    strongSelf.delegate?.timerCameraOverlayViewDidFire(strongSelf)  // fires
                } else {
                    strongSelf.decreaseTime(remainingSecs - 1)  // decreases by 1 sec
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        label = UILabel()
        button = UIButton()
        
        super.init(frame: frame)
        
        addSubview(label)
        addSubview(button)
        
        // Time label
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.systemFontOfSize(40, weight: UIFontWeightMedium)
        label.sizeToFit()
        label.frame.origin = CGPoint(x: frame.width/2 - 8, y: frame.height - 80)
        
        // Cancel button
        button.setTitle("Cancelar", forState: .Normal)
        button.titleLabel?.textColor = UIColor.whiteColor()
        button.titleLabel?.font = UIFont.systemFontOfSize(20, weight: UIFontWeightRegular)
        button.addTarget(self, action: "cancel:", forControlEvents: .TouchUpInside)
        button.sizeToFit()
        button.frame.origin = CGPoint(x: 20, y: frame.height - 70)
    }
    
    /// Stops the timer and notifies the delegate
    func cancel(sender: AnyObject) {
        started = false
        delegate?.timerCameraOverlayViewDidCancel(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol TimerCameraOverlayViewDelegate: class {
    func timerCameraOverlayViewDidCancel(overlayView: UIView)
    func timerCameraOverlayViewDidFire(overlayView: UIView)
}
