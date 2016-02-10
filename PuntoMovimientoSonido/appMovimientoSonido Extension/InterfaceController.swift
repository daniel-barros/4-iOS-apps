//
//  InterfaceController.swift
//  appMovimientoSonido Extension
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

import WatchKit
import WatchConnectivity
import Foundation
import CoreMotion


class InterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var label: WKInterfaceLabel!
    var firstTime = true
    
    var session = WCSession.defaultSession()
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        session.delegate = self
        session.activateSession()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
}


// MARK: WCSessionDelegate
extension InterfaceController {
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        
        mainQueue {
            if message[WatchMessageKeys.switchOff] != nil {
                self.label.setText("Acciona el interruptor en la aplicación de iPhone para empezar")
                self.firstTime = true
            } else {
                let phase = ButterGesturePhase(rawValue: message[WatchMessageKeys.phaseChange] as! Int)!
                if phase == .Beginning {
                    if !self.firstTime {
                        self.label.setText("Gesto detectado!")
                        delay(1) { [weak self] in
                            self?.label.setText(phase.helpMessage)
                        }
                        return
                    } else {
                        self.firstTime = false
                    }
                }
                self.label.setText(phase.helpMessage)
            }
        }
    }
}

extension ButterGesturePhase {
    var helpMessage: String {
        switch self {
        case .Beginning: return "Pon tu iPhone mirando hacia arriba y muévelo hacia la derecha"
        case .MovingRight: return "Pon tu iPhone mirando hacia abajo y muévelo hacia la izquierda"
        case .MovingLeft: return "Pon tu iPhone mirando hacia arriba para terminar"
        }
    }
}
