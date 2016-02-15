//
//  CardinalPoint.swift
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


/// Cardinal point enum. Raw values are the corresponding degrees.
enum CardinalPoint: Int {
    case North = 0, South = 180, East = 90, West = 270
    
    /// Initializes from the cardinal point name in Spanish, loosely spelled
    init?(string: String) {
        switch string.capitalizedString {
        case "Norte":
            self = .North
        case "Sur":
            self = .South
        case "Este", "Éste", "Esté":
            self = .East
        case "Oeste", "O Este":
            self = .West
        default:
            return nil
        }
    }
    
    /// Cardinal point name in Spanish
    var name: String {
        switch self {
        case .North:
            return "Norte"
        case .South:
            return "Sur"
        case .East:
            return "Este"
        case .West:
            return "Oeste"
        }
    }
}
