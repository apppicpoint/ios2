import Foundation
import Alamofire

//Esta clase es necesaria para detectar cuando el movil esta sin internet y tenerlo en cuenta a la hora de comunicarme con mi api
class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
