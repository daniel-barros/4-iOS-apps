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

/// Full screen camera extension for UIImagePickerController
extension UIImagePickerController {
        
    /// Transforms camera view to fill the screen
    func scaleCameraViewToFillScreen() {
        sourceType = .Camera
        
        let translateTransform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, cameraViewTranslationY)
        let scaleTransform = CGAffineTransformScale(translateTransform, cameraViewScaleFactor, cameraViewScaleFactor)
        cameraViewTransform = scaleTransform
        
    }
    
    private struct Constants {
        static let cameraViewHeightRatio: CGFloat = 0.1252467766
        static let cameraScaleRatio: CGFloat = 1.3333333333
    }
    
    private var cameraViewTranslationY: CGFloat {
        return UIScreen.mainScreen().bounds.height * Constants.cameraViewHeightRatio
    }
    
    /// Scale factor needed to make the camer view fill the screen
    private var cameraViewScaleFactor: CGFloat {
        let screenAspectRatio = UIScreen.mainScreen().bounds.width / UIScreen.mainScreen().bounds.height
        let scaleRatio = Constants.cameraScaleRatio / screenAspectRatio
        let scaleFactor = screenAspectRatio * scaleRatio
        return scaleFactor
    }
}
