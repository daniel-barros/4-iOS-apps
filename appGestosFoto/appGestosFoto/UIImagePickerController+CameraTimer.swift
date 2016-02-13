//
//  TimerImagePickerController.swift
//  appGestosFoto
//
//  Created by Daniel Barros López and Yoji Sargent Harada
//  Last modification on Feb 12 2016
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

/// Camera timer extension for UIImagePickerController
extension UIImagePickerController {
    
    /// Call this before `startCameraTimer(seconds:)`
    func setUpCameraTimer() {
        sourceType = .Camera
        showsCameraControls = false
        setTimerCameraOverlayView()
    }
    
    /// Use only when `sourceType` is `.Camera`
    func startCameraTimer(seconds: Int) {
        (cameraOverlayView as? TimerCameraOverlayView)?.startTimer(seconds)
    }
    
    private func setTimerCameraOverlayView() {
        let overlayView = TimerCameraOverlayView(frame: view.frame)
        overlayView.delegate = self
        cameraOverlayView = overlayView
    }
    
}

// MARK: TimerCameraOverlayViewDelegate

extension UIImagePickerController: TimerCameraOverlayViewDelegate {
    func timerCameraOverlayViewDidCancel(overlayView: UIView) {
        cameraOverlayView = nil
        setTimerCameraOverlayView() // frees current cameraOverlayView
        delegate?.imagePickerControllerDidCancel?(self)
    }
    
    func timerCameraOverlayViewDidFire(overlayView: UIView) {
        self.takePicture()
    }
}
