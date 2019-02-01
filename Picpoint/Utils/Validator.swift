//
//  Validator.swift
//  Picpoint
//
//  Created by David on 29/01/2019.
//  Copyright © 2019 Joaquín Collazo Ruiz. All rights reserved.
//
import UIKit
import Foundation

class  Validator {
    
    
    // Tiene ue tener texto antes de la @, una @, texto despues, y un . con algo. Osea un email válido.
    func isValidEmailAddress(string: String) -> Bool {
        var returnValue = true
        let regularExpresion = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: regularExpresion)
            let nsString = string as NSString
            let results = regex.matches(in: string, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        return  returnValue
    }
    
    // Nombre entre 3 y 16 caracteres. Solo caracteres alfanumericos.
        func isValidNickName(string: String) -> Bool {
            var returnValue = true
            let regularExpresion = "^[a-z0-9_-]{3,16}$"
            
            do {
                let regex = try NSRegularExpression(pattern: regularExpresion)
                let nsString = string as NSString
                let results = regex.matches(in: string, range: NSRange(location: 0, length: nsString.length))
                
                if results.count == 0
                {
                    returnValue = false
                }
                
            } catch let error as NSError {
                print("invalid regex: \(error.localizedDescription)")
                returnValue = false
            }
            return  returnValue
        }
    
    // Pass entre 8 y 16 caracteres. Puede haber caracteres especiales. Obligatorio al menos un numero y una letra.

    func isValidPassword(string: String) -> Bool {
        var returnValue = true
        let regularExpresion = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d@$!%*#?&]{8,16}$"
        
        do {
            let regex = try NSRegularExpression(pattern: regularExpresion)
            let nsString = string as NSString
            let results = regex.matches(in: string, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        return  returnValue
    }
        
        
        
}
