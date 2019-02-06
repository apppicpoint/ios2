import Foundation
import Alamofire
import MapKit

//Esta clase es necesaria para detectar cuando el movil esta sin internet y tenerlo en cuenta a la hora de comunicarme con mi api
class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    class func isLocationEnabled() ->Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                print("Not determined")
                return false
            case .restricted:
                print("Restricted")
                return false
            case .denied:
                print("Denied")
                return false
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                return true
            }
        } else {
            print("Location services are not enabled")
            return false
        }
    }
}
