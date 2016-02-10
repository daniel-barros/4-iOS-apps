//
//  Int+StringInit.swift
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

extension Int {
    
    static let numbers = ["uno": 1, "dos": 2, "tres": 3, "cuatro": 4, "cinco": 5,
                        "seis": 6, "siete": 7, "ocho": 8, "nueve": 9, "diez": 10]
    
    /// Initializes from a string containing the number word in spanish.
    /// Valid for numbers from 1 to 10.
    init?(string: String) {
        if let integer = Int(string) {
            self = integer
        } else if let integer = Int.numbers[string] {
            self = integer
        } else {
            return nil
        }
    }
}