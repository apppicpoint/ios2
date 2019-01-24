import Foundation
//Arrays registro hardcoded
var emailRegister: [String] = []
var nameRegister: [String] = []
var passwordRegister: [String] = []

//Arrays login hardcoded
var emailLogin: [String] = []
var passwordLogin: [String] = []
var checkLoginTrue: [String] = []

var token = String()

func saveInDefaults(value: String, key: String)
{
    let UserSave = UserDefaults.standard
    UserSave.set(value, forKey: key)
    UserSave.synchronize()
}
func loadFromDefaults(key: String) -> String
{
    let UserLoad = UserDefaults.standard
    var value = String()
    value = UserLoad.object(forKey: key) as! String
    return value
}
