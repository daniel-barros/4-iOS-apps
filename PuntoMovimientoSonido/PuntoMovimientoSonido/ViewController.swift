//
//  ViewController.swift
//  PuntoMovimientoSonido
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
import CoreMotion
import AVFoundation
import WatchConnectivity

// Handles a view containing a switch that turns on/off gesture recognition.
// The gesture consists on turning over the device and moving it left/right
// It communicates with Apple Watch for step by step guidance
// When gesture is detected device will play a sound and vibrate
class ViewController: UIViewController, WCSessionDelegate {
    
    let manager = CMMotionManager()
    var timer: NSTimer?
    var player: AVAudioPlayer!
    let session: WCSession? = WCSession.isSupported() ? WCSession.defaultSession() : nil
    /// - returns: `session` property if watch is paired and reachable, and app is installed. `nil` otherwise
    var validSession: WCSession? {
        if let validSession = session where validSession.paired && validSession.watchAppInstalled && validSession.reachable {
            return validSession
        } else {
            return nil
        }
    }
    
    struct Constants {
        static let gestureRecognitionUpdateInterval = 0.05
        static let gestureMinXAcceleration = 0.1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Loads sound
        let url = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("buttonIn.mp3", ofType: nil)!)
        player = try! AVAudioPlayer(contentsOfURL: url)
        
        // Set up Apple Watch connectivity session
        session?.delegate = self
        session?.activateSession()
    }
    
    // State of gesture recognition. Notifies Apple Watch with each change
    var gesturePhase = ButterGesturePhase.Beginning {
        didSet {
            validSession?.sendMessage([WatchMessageKeys.phaseChange: gesturePhase.rawValue], replyHandler: nil, errorHandler: nil)
        }
    }
    
    // Recognizes current gesture and moves to next step if proper
    func detectPattern() {
        guard let xAcc = manager.deviceMotion?.userAcceleration.x else {
            return
        }
        
        switch gesturePhase {
        case .Beginning:
            if UIDevice.currentDevice().orientation == .FaceUp && xAcc > Constants.gestureMinXAcceleration {
                gesturePhase = .MovingRight
            }
        case .MovingRight:
            if UIDevice.currentDevice().orientation == .FaceDown && xAcc < -Constants.gestureMinXAcceleration {
                gesturePhase = .MovingLeft
            }
        case .MovingLeft:
            if UIDevice.currentDevice().orientation == .FaceUp {
                gesturePhase = .Beginning
                patternDetected()
            }
        }
    }
    
    /// Plays a sound and makes device vibrate
    func patternDetected() {
        player.prepareToPlay()
        player.play()
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))  // makes device vibrate
    }
    
    deinit {
        timer?.invalidate()
        manager.stopDeviceMotionUpdates()
    }

    @IBAction func startPattern(sender: UISwitch) {
        if sender.on {
            // Starts gesture recognition (a method called regularly using a repeating timer)
            if manager.deviceMotionAvailable {
                manager.deviceMotionUpdateInterval = Constants.gestureRecognitionUpdateInterval
                manager.startDeviceMotionUpdates()
                timer = NSTimer(timeInterval: Constants.gestureRecognitionUpdateInterval, target: self, selector: "detectPattern", userInfo: nil, repeats: true)
                NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSDefaultRunLoopMode)
                gesturePhase = .Beginning
            }
        } else {
            // Stops gesture recognition
            timer?.invalidate()
            manager.stopDeviceMotionUpdates()
            validSession?.sendMessage([WatchMessageKeys.switchOff: ""], replyHandler: nil, errorHandler: nil)
        }
    }
}
