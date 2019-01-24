import Foundation
//Funciones relacionadas con el guardado y carga de datos
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
