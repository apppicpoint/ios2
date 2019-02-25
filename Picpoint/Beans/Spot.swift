//
//  Spot.swift
//  Picpoint
//
//  Created by David on 01/02/2019.
//  Copyright © 2019 Joaquín Collazo Ruiz. All rights reserved.
//

import Foundation
import UIKit

class Spot {
    var id: Int?
    var name:String?
    var desc: String?
    var longitude: Double?
    var latitude: Double?
    var distance: Float?
    var user_id: Int?
    var image: UIImage?
    
    init() {
        
    }
    init(id: Int, name: String, desc: String?, longitude:Double, latitude:Double, user_id:Int, distance: Float?) {
        self.id = id
        self.name = name
        self.desc = desc
        self.longitude = longitude
        self.latitude = latitude
        self.user_id = user_id
        self.distance = distance
    }
}
