//
//  MapTableViewCell.swift
//  Picpoint
//
//  Created by David on 01/02/2019.
//  Copyright © 2019 Joaquín Collazo Ruiz. All rights reserved.
//

import UIKit
import MapKit

class MapFeedViewController:MKMapView , CLLocationManagerDelegate, MKMapViewDelegate {
    
    var spots = [Spot]()
    var currentLongitude: Double?
    var currentLatitude: Double?
    let locationManager = CLLocationManager()
    
    //@IBOutlet weak var map: MKMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
    }
    
    
    @IBAction func centerMapBtn(_ sender: UIButton) {
        centerMap()
    }
    
    
    // Centra el mapa
    func centerMap(){
        let coordinates = CLLocationCoordinate2D.init(latitude: locationManager.location!.coordinate.latitude, longitude: locationManager.location!.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinates, span: span)
        self.setRegion(region, animated: true)
    }
    
    // Actualiza el mapa
    func updateMap() {
        print("Actualizando mapa")
        self.removeAnnotations(self.annotations) //Borra todas las anotaciones existentes para que no se repitan.
        for (index, spot) in spots.enumerated() {
            let coordinates = CLLocationCoordinate2DMake(spot.latitude!, spot.longitude!) // Establece las coordenadas del pin.
            let mark = PinAnnotation(pinTitle: spot.name, pinSubTitle: spot.desc, location: coordinates, id:index)           // Crea el marcador
            self.addAnnotation(mark) // Añade el pin al mapa.
        }
        
    }
    
    //Modifica el comportamiento de los pines
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customannotaion") //Crea una vista personalizada del pin.
        
        annotationView.isEnabled = true // Activa el marcador.
        annotationView.canShowCallout = true // Establece si puede mostrar informacion extra en la burbuja
        annotationView.image = UIImage(named: "pin_full") // Establece la imagen del pin.
        annotationView.centerOffset = CGPoint(x:0, y:(annotationView.image!.size.height / -2));
        

        //Crea un botón derecho en la burbuja personalizado.
        let calloutRightImage = UIImage(named: "point_active")
        let calloutRightButton = UIButton(type: .custom)
        calloutRightButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        calloutRightButton.setImage(calloutRightImage, for: .normal)
        annotationView.rightCalloutAccessoryView = calloutRightButton
        
        configureDetailView(annotationView: annotationView)

        return annotationView
    }
    
    //Se llama al pulsar cada Pin
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // VACIO
        print("pulsado")

    }
    
    func configureDetailView(annotationView: MKAnnotationView) {
        let width = 60
        let height = 30
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        view.tintColor = .red
        

        
        annotationView.detailCalloutAccessoryView = view
    }
    
}
