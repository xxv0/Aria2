//
//  GlobalStatusModel.swift
//  Aria2
//
//  Created by my on 2022/10/11.
//

import UIKit

struct GlobalStatusModel: HandyJSON {
    
    var numActive = 0
    var numStoppedTotal = 0
    var uploadSpeed = 0
    var numWaiting = 0
    var downloadSpeed = 0
    var numStopped = 0

}
