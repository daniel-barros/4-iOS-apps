//
//  ViewController.swift
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

/// Handles a view containing a button. Pressing this button shows up the keyboard, and dictating a proper orientation using Siri triggers the segue to a Compass view
class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    var recognizedOrientation: Orientation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = ""
    }
    
    /// Shows up a the keyboard
    @IBAction func getOrientation(sender: UIButton) {
        textField.becomeFirstResponder()
        UIView.animateWithDuration(0.2) {
            self.button.alpha = 0
        }
    }
    
    // MARK: Segues handling
    
    // (sets up compass view)
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showCompassSegue" {
            let vc = segue.destinationViewController as! CompassViewController
            vc.orientation = recognizedOrientation
        }
    }
    
    // (Back from compass view)
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        label.text = ""
        button.alpha = 1
    }
    
    // MARK: UITextFieldDelegate
    
    // Returns false always, forcing to use Siri dictation in order to write more than one character at a time
    // If an Orientation instance can be initialized from the new string, a segue to a compass view is triggered
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        self.label.alpha = 1
        
        if let orientation = Orientation(stringFromSpeechRecognition: string) {     // orientation recognized
            textField.resignFirstResponder()
            label.textColor = UIColor.greenColor()
            label.text = orientation.description
            recognizedOrientation = orientation
            delay(1) {
                self.performSegueWithIdentifier("showCompassSegue", sender: self)
            }
        } else {    // orientation not recognized
            label.textColor = UIColor.redColor()
            label.text = "\"\(string)\"\nNo se ha reconocido el patrón.\n Usa Siri para dictar un punto cardinal seguido de un número entero."
            delay(2) {
                UIView.animateWithDuration(0.3) {
                    self.label.alpha = 0
                }
            }
        }
        return false
    }
}

