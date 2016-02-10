//
//  GlobalFunctions.swift
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

import Foundation

func delay(delay: Double, block: dispatch_block_t) {
    let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)));
    dispatch_after(popTime, dispatch_get_main_queue(), block)
}

func mainQueue(block: dispatch_block_t) {
    dispatch_async(dispatch_get_main_queue(), block)
}

enum QueueQualityOfService {
    case UserInteractive, UserInitiated, Utility, Background
    
    var GCDValue: qos_class_t {
        switch self {
        case .UserInteractive: return QOS_CLASS_USER_INTERACTIVE
        case .UserInitiated: return QOS_CLASS_USER_INITIATED
        case .Utility: return QOS_CLASS_UTILITY
        case .Background: return QOS_CLASS_BACKGROUND
        }
    }
}

func concurrentQueue(qos: QueueQualityOfService, block: dispatch_block_t) {
    dispatch_async(dispatch_get_global_queue(qos.GCDValue, 0), block)
}
