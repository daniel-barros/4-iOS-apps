//
//  ViewController.swift
//  appGestosFoto
//
//  Created by Daniel Barros López and Yoji Sargent Harada
//  Last modification on Feb 10 2016
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

/// Handles a view containing a button for recording a pattern, a BoardView managed by its own view controller in charge of the pattern logic, and an image that will show the last picture taken by the camera when the correct pattern is introduced.
class ViewController: UIViewController, PatternViewDelegate, UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!  // Shows last picture taken
    weak var cameraOverlayView: TimerCameraOverlayView? // Overlay view for image picker that shows a timer
    let picker = UIImagePickerController()
    @IBOutlet weak var newPatternButton: UIButton!
    
    var patternViewController: PatternViewController {
        return childViewControllers.first as! PatternViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        patternViewController.delegate = self
        
        // Set up image picker
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            picker.sourceType = .Camera
            picker.showsCameraControls = false
            let overlayView = TimerCameraOverlayView();
            picker.cameraOverlayView = overlayView
            self.cameraOverlayView = overlayView
            picker.delegate = self
        }
        
        // App starts saving new pattern
        startSavingPattern(self)
    }
    
    @IBAction func startSavingPattern(sender: AnyObject) {
        newPatternButton.enabled = false
        patternViewController.startSavingNewPattern()
    }
    
    // MARK: PatternViewDelegate
    
    func didSaveNewPattern() {
        newPatternButton.enabled = true
    }
    
    func didMatchPattern() {
        // Show image picker
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            presentViewController(picker, animated: true, completion: {
                delay(3) {
                    self.picker.takePicture()
                }
            })
        }
    }
    
    // MARK: UIImagePickerControllerDelegate

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.imageView.alpha = 0
        dismissViewControllerAnimated(true, completion: {
            UIView.animateWithDuration(0.2) {
                self.imageView.alpha = 1
            }
        })
    }
    
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        // Start timer once picker is shown
        if navigationController == picker {
            self.cameraOverlayView!.start3secTimer()
        }
    }
}

