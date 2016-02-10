//
//  Orientation.swift
//  appFotoVoz
//
//  Created by Daniel Barros López and Yoji Sargent Harada
//  Last modification on Feb 6 2016
//
//    Copyright (C) 2015  Yoji Sargent Harada, Daniel Barros López
//
//    This program is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    any later version.
//
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

import Foundation


/// Represents an orientation, defined by a cardinal point an an error given in degrees
struct Orientation {
    var cardinalPoint: CardinalPoint
    var error: Int
    
    /// Checks if a given angle (in degrees) corresponds to the cardinal point within a certain error
    func containsAngle(angle: Double) -> Bool {
        return (angle >= Double(cardinalPoint.rawValue - error)) &&
            (angle <= Double(cardinalPoint.rawValue + error))
    }
}


extension Orientation {
    
    /// Initializes from a string containing the cardinal point name and an integer, in Spanish
    init?(stringFromSpeechRecognition string: String) {
        let words = string.componentsSeparatedByString(" ")
        if !(words.count == 2 || words.count == 3) {
            return nil
        }
        let cardinalString = words.count == 2 ? words[0] : words[0] + " " + words[1]
        
        guard let point = CardinalPoint(string: cardinalString),
            degrees = Int(string: words.last!) else {
                return nil
        }
        self = Orientation(cardinalPoint: point, error: degrees)
    }
}


extension Orientation: CustomStringConvertible {
    
    var description: String {
        return "Orientación: \(cardinalPoint.name)  Error: \(error)°"
    }
}
