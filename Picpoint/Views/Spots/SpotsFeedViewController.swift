//
//  SpotsFeedViewController.swift
//  Picpoint
//
//  Created by David on 29/01/2019.
//  Copyright © 2019 Joaquín Collazo Ruiz. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import MapKit

class SpotsFeedViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    @IBOutlet weak var map: MapFeedViewController!
    
    @IBOutlet weak var spotsTableView: SpotsTableView!
    var spots = [Spot]()
    var currentLongitude: Double?
    var currentLatitude: Double?
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Configura los delegados del controlador de ubicaciones
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        print("comprobado")
        locationManager.startUpdatingLocation()

        if Connectivity.isLocationEnabled() {
            //Obtiene las coordenadas actuales del usuario.
            currentLatitude = locationManager.location!.coordinate.latitude
            currentLongitude = locationManager.location!.coordinate.longitude
            
            //Pasa las coordenadas al mapa
            map.currentLatitude = currentLatitude
            map.currentLongitude = currentLongitude
            
            //Obtiene la lista de spots
            getSpots()
            
            //Centra el mapa
            map.centerMap()
        } else {
            let alert = UIAlertController(title: "Pls! Activate the GPS", message:
                "Picpoint cannot work without it", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style:
                .cancel, handler: { (accion) in}))
            self.present(alert, animated: true, completion: nil)
        }
        
        //Configura los delegados de la tabla
        spotsTableView.delegate = self
        spotsTableView.dataSource = self
        
        
        spotsTableView.scroll(to: .top, animated: true) // Se actualiza la tabla al hacer scroll hacia arriba
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        manager.startUpdatingLocation() // Determina la ubicación actual del usuario
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (spots.count)
    }
    
    // Rellena cada una de las celdas con su información correspondiente.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = SpotTableViewCell()
        
        cell = tableView.dequeueReusableCell(withIdentifier: "spotCell", for: indexPath) as! SpotTableViewCell
        cell.titleTextField.text = spots[indexPath.row].name
        cell.distanceTextField.text = String(spots[indexPath.row].distance!) + " km from you"
        cell.imageView?.image = spots[indexPath.row].image
        
        return cell
    }
    
    // Establece la altura de las columnas de la tabla
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        return 85 // Tamaño de la celda de spots
    }
    
    
    
    func getSpots() {
        print("obteniendo spots")
        spots = [Spot]()
        let url = Constants.url+"distance"
        let _headers : HTTPHeaders = [
            "Content-Type":"application/x-www-form-urlencoded",
            "Authorization":UserDefaults.standard.string(forKey: "token")!
        ]
        let parameters: Parameters = [
            "longitude":currentLongitude!,
            "latitude":currentLatitude!,
            "distance":150 // km
        ]
        Alamofire.request(url, method: .post,parameters: parameters, encoding: URLEncoding.httpBody, headers: _headers).responseJSON{
            response in
            
            switch response.result {
            case .success:
                if(response.response?.statusCode == 200){
                    let jsonResponse = response.result.value as! [String:Any]
                    let data = jsonResponse["spots"] as! [[String: Any]]
                    for dataItem in data {
                        let distance = dataItem["distance_user"] as! Double
                        let spot = Spot(id: dataItem["id"] as! Int,
                                        name: dataItem["name"] as! String,
                                        desc: dataItem["description"] as? String,
                                        longitude: dataItem["longitude"] as! Double,
                                        latitude: dataItem["latitude"] as! Double,
                                        user_id: dataItem["user_id"] as! Int,
                                        distance: Float(round(10*distance)/10))
                        self.spots.append(spot) //Por cada objeto en el json se añade un spot al array.
                        self.getSpotImage(imageName: dataItem["image"] as! String, spot: spot)
                    }
                    self.map.spots = self.spots // Le pasa los spots.
                    self.map.updateMap() //Actualiza los spots en el mapa                    
                }
            //Si falla la conexión se muestra un alert.
            case .failure(let error):
                print("Sin conexión")
                print(error)
                let alert = UIAlertController(title: "Ups! Something was wrong.", message:
                    "Check your connection and try it later", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style:
                    .cancel, handler: { (accion) in}))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func getSpotImage(imageName: String, spot: Spot){
        let url = Constants.url+"img/"+imageName //Se le pasa el nombre de la foto, el cual lo tiene el spot.
        Alamofire.request(url, method: .get).responseImage { response in
            switch response.result {
            case .success:
                let data = response.result.value
                spot.image = data
                self.spotsTableView.reloadData()
            case .failure(let error):
                print("Sin conexión")
                print(error)
                let alert = UIAlertController(title: "Ups! Something was wrong.", message:
                    "Check your connection and try it later", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style:
                    .cancel, handler: { (accion) in}))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    
    //Prepara la clase de destino.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is SpotDetailViewController {            
            let destination = segue.destination as! SpotDetailViewController
            let cell = sender as! SpotTableViewCell
            print(cell.id!)
            destination.spot = spots[cell.id!]
        }
    }
    
    //Necesario para unwind segue. Es para hacer dissmis de varias pantallas a la vez. No es necesario que tenga nada dentro.
    @IBAction func backFromNewSpotToFeed(_ segue: UIStoryboardSegue) {
        print("he volvido")
        getSpots()
    }
}
