
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

class SpotsFeedViewController: UIViewController,  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MapFeedViewController!
    
    @IBOutlet weak var spotsCollecionView: SpotsCollectionViewController!
    var spots = [Spot]()
    var currentLongitude: Double?
    var currentLatitude: Double?
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Configura los delegados del controlador de ubicaciones
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //Configura los delegados de la tabla
        spotsCollecionView.delegate = self
        spotsCollecionView.dataSource = self
        
        map.tintColor = UIColor.init(red: 15, green: 188, blue: 249, alpha: 1)
        
        
        //spotsTableView.scroll(to: .top, animated: true) // Se actualiza la tabla al hacer scroll hacia arriba
        
        // Comprobacines de conectividad y ubicación
        if Connectivity.isLocationEnabled() && Connectivity.isConnectedToInternet(){
            //Obtiene las coordenadas actuales del usuario.
            currentLatitude = locationManager.location!.coordinate.latitude
            currentLongitude = locationManager.location!.coordinate.longitude
            
            //Obtiene la lista de spots
            getSpots()
            
            //Centra el mapa
            map.centerMap()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.spotsCollecionView.reloadData()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func centerMapBtn(_ sender: UIButton) {
        map.centerMap()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        manager.startUpdatingLocation() // Determina la ubicación actual del usuario
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (spots.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("SELECTED")
        /*let vc = self.storyboard?.instantiateViewController(withIdentifier: "SpotDetailViewController" ) as! SpotDetailViewController
         vc.spot = spots[indexPath.row]*/
        let sender = collectionView.cellForItem(at: indexPath)
        performSegue(withIdentifier: "goToDetail", sender: sender)
        //self.present(vc, animated: true, completion: nil)
        //navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = SpotCollectionViewCell()
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "spotCell", for: indexPath) as! SpotCollectionViewCell
        cell.id = spots[indexPath.row].id
        cell.index = indexPath.row
        cell.titleTextField.text = spots[indexPath.row].name
        cell.distanceTextField.text = String(spots[indexPath.row].distance!) + "km from you"
        cell.spotImage?.layer.masksToBounds = true
        cell.spotImage?.contentMode = .scaleAspectFill
        cell.spotImage?.image = spots[indexPath.row].image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 280, height: 75)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let visibleRect = CGRect(origin: spotsCollecionView.contentOffset, size: spotsCollecionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let indexPath = spotsCollecionView.indexPathForItem(at: visiblePoint)
        
        if(indexPath != nil)
        {
            let cell = spotsCollecionView.cellForItem(at: indexPath!) as! SpotCollectionViewCell
            
            //print("************************* id loclizaciones")
            //print("*************************" , cell.id!)
            
            for pin in map.annotations
            {
                //print("bucle")
                
                if (pin is MKUserLocation)
                {
                    //print("MKUserLocation")
                    //print("-------------------------------------------")
                    continue
                }
                
                let pinSelected = pin as! PinAnnotation
                
                if(cell.id! == pinSelected.id!)
                {
                    //print(cell.id! , "celda", pinSelected.id! , "pin" , "true")
                    //print("-------------------------------------------")
                    
                    map.centerMapLocation(latitude: spots[cell.index!].latitude! , longitude: spots[cell.index!].longitude!)
                    resizePinImage(pin: pin, width: 40, height: 65, nameImage: "pin_full")
                }else
                {
                    //print(cell.id! , "celda", pinSelected.id! , "pin" , "false")
                    //print("-------------------------------------------")
                    resizePinImage(pin: pin, width: 15, height: 15, nameImage: "circle_point")
                }
            }
        }
    }
    
    func resizePinImage(pin:MKAnnotation,width:Int,height:Int,nameImage:String){
        
        let pinView = map.view(for: pin)
        pinView?.canShowCallout = true
        
        // Cambiar imagen de tamaño
        let pinImage = UIImage(named: nameImage)
        let size = CGSize(width: width, height: height) //proporcion 0.625
        UIGraphicsBeginImageContext(size)
        pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        pinView?.image = resizedImage
        if(nameImage == "pin_full") {
            pinView?.centerOffset = CGPoint(x:0, y:((pinView?.image!.size.height)! / -2));
        }else {
            pinView?.centerOffset = CGPoint(x:0, y:0);
        }
        
        
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
                        
                        let dataTag = dataItem["tags"] as! [[String:Any]]
                        
                        var tags = [Tag]()
                        for dataTagItem in dataTag {
                            let tag = Tag(id: dataTagItem["id"] as! Int, name: dataTagItem["name"] as! String)
                            tags.append(tag)
                        }
                        
                        
                        let spot = Spot(id: dataItem["id"] as! Int,
                                        name: dataItem["name"] as! String,
                                        desc: dataItem["description"] as? String,
                                        longitude: dataItem["longitude"] as! Double,
                                        latitude: dataItem["latitude"] as! Double,
                                        user_id: dataItem["user_id"] as! Int,
                                        distance: Float(round(10*distance)/10),
                                        imageName: dataItem["image"] as? String,
                                        tags: tags)
                        //print("*** tags ", spot.tags!.count)
                        print("*** spot ", spot.tags?.count)
                        self.spots.append(spot) //Por cada objeto en el json se añade un spot al array.
                        self.getSpotImage(imageName: spot.imageName!, spot: spot)
                        
                    }
                    
                    self.map.spots = self.spots // Le pasa los spots.
                    self.map.updateMap() //Actualiza los spots en el mapa
                    self.spotsCollecionView.reloadData()
                }
            //Si falla la conexión se muestra un alert.
            case .failure(let error):
                print("Sin conexión en get spot")
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
        let url = Constants.url+"imgLow/"+imageName //Se le pasa el nombre de la foto, el cual lo tiene el spot.
        Alamofire.request(url, method: .get).responseImage { response in
            switch response.result {
            case .success:
                let data = response.result.value
                spot.image = data!
                self.spotsCollecionView.reloadData()
            case .failure(let error):
                print("Sin conexión en get spot image")
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
            let cell = sender as! SpotCollectionViewCell
            print(cell.id!)
            destination.spot = spots[cell.index!]
            
        }
    }
    
    //Necesario para unwind segue. Es para hacer dissmis de varias pantallas a la vez. No es necesario que tenga nada dentro.
    @IBAction func backFromNewSpotToFeed(_ segue: UIStoryboardSegue) {
        print("he volvido")
        getSpots()
    }
}


// Rellena cada una de las celdas con su información correspondiente.
/*func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 var cell = SpotTableViewCell()
 
 cell = tableView.dequeueReusableCell(withIdentifier: "spotCell", for: indexPath) as! SpotTableViewCell
 cell.titleTextField.text = spots[indexPath.row].name
 cell.distanceTextField.text = String(spots[indexPath.row].distance!) + " km from you"
 cell.spotImage?.layer.masksToBounds = true
 cell.spotImage?.contentMode = .scaleAspectFill
 cell.spotImage?.image = spots[indexPath.row].image
 
 print(cell.imageView?.clipsToBounds)
 
 return cell
 }*/

// Establece la altura de las columnas de la tabla
/*func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
 {
 
 return 85 // Tamaño de la celda de spots
 }*/

/*func numberOfSections(in tableView: UITableView) -> Int {
 return 1
 }
 
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 return (spots.count)
 }*/
