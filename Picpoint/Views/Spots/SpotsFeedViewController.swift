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

class SpotsFeedViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var spotsTableView: SpotsTableView!
    @IBOutlet weak var map: MapViewController!
    var spots = [Spot]()

    override func viewDidLoad() {
        super.viewDidLoad()
        spotsTableView.delegate = self
        spotsTableView.dataSource = self
        getSpots()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (spots.count+1)
    }
    
    // Rellena cada una de las celdas con su información correspondiente.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = SpotTableViewCell()
        
        if indexPath.row == 0 {
            let mapCell = tableView.dequeueReusableCell(withIdentifier: "mapCell", for: indexPath) as! MapTableViewCell

            return mapCell
            
        } else if indexPath.row != 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "spotCell", for: indexPath) as! SpotTableViewCell
            cell.titleTextField.text = spots[indexPath.row-1].name
            print(indexPath.row)
            cell.distanceTextField.text = String(spots[indexPath.row-1].distance!)
            cell.imageView?.image = spots[indexPath.row-1].image
            print("entra")
            return cell
        }
        return cell
    }
    
    // Establece la altura de las columnas de la tabla
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0 {
            return 450 // Tamaño del mapa
        }
        return 130 // Tamaño de la celda de spots
    }
    
    func getSpots() {
        let url = Constants.url+"distance"
        let _headers : HTTPHeaders = [
            "Content-Type":"application/x-www-form-urlencoded",
            "Authorization":UserDefaults.standard.string(forKey: "token")!
        ]
        let parameters: Parameters = [
            "lon1":23,
            "lat1":2,
            "distanceUser":150
        ]
        Alamofire.request(url, method: .post,parameters: parameters, encoding: URLEncoding.httpBody, headers: _headers).responseJSON{
            response in
            
            switch response.result {
            case .success:
                if(response.response?.statusCode == 200){
                    let jsonResponse = response.result.value as! [String:Any]
                    let data = jsonResponse["spots"] as! [[String: Any]]
                    for dataItem in data {
                        let spot = Spot(id: dataItem["id"] as! Int,
                                        name: dataItem["name"] as! String,
                                        desc: dataItem["description"] as? String,
                                        longitude: dataItem["longitude"] as! Double,
                                        latitude: dataItem["latitude"] as! Double,
                                        user_id: dataItem["user_id"] as! Int,
                                        //image: dataItem["image"] as? String,
                                        distance: dataItem["distance_user"] as? Float)
                        self.spots.append(spot) //Por cada objeto en el json se añade una ubicación al array.
                        self.getSpotImage(imageName: dataItem["image"] as! String, spot: spot)
                        print(self.spots.count)
                    }
                    
                    // Si la tabla está vacia se muestra una imagen.
                    if self.spots.isEmpty {
                        let backgroundImage = UIImage(named: "empty")
                        let imageView = UIImageView(image: backgroundImage)
                        self.spotsTableView.backgroundView = imageView
                    } else{
                        self.spotsTableView.backgroundView = UIView.init()
                    }
                    self.spotsTableView.reloadData() // Refresca la tabla.
                }
                
            case .failure(let error):
                print(error)
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
                print("Imagen descargada", data.debugDescription)
                self.spotsTableView.reloadData()
            case .failure(let error):
                print(error, imageName)
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

}
