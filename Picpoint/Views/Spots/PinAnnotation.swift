import MapKit
import Foundation
import UIKit

class PinAnnotation : NSObject, MKAnnotation {
    
    // Crea un pin personalizado para poder modificar su aspecto y comportamiento.
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var id:Int?
    
    init(pinTitle:String?, pinSubTitle: String?, location:CLLocationCoordinate2D, id:Int)
    {
        self.title = pinTitle
        self.subtitle = pinSubTitle
        self.coordinate = location
        self.id = id
    }
}
