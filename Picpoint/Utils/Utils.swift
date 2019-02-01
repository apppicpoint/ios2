//
//  Utils.swift
//  Picpoint
//
//  Created by David on 31/01/2019.
//  Copyright © 2019 Joaquín Collazo Ruiz. All rights reserved.
//

import Foundation

struct Constants {
   // static let url = "http://192.168.6.162/api/public/index.php/api/"
    static let url = "http://localhost:8888/api/public/index.php/api/"

}

class Utils {
    //Devuelve un string aleatorio entre mayusculas, minusculas y numeros.
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0...length-1).map{ _ in letters.randomElement()! })
    }
    
}
