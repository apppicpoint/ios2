//
//  NewSpotViewController.swift
//  Picpoint
//
//  Created by David on 29/01/2019.
//  Copyright © 2019 Joaquín Collazo Ruiz. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import MapKit

class NewSpotViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {

    var image: UIImage?
    var imageName: String?
    var longitude: Double?
    var latitude: Double?
    var city: String?
    var country: String?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var tagsTextField: UITextField!
    let utils = Utils()

    @IBAction func tagsBtn(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myAlert = storyboard.instantiateViewController(withIdentifier: "tagPopUp")
        myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(myAlert, animated: true, completion: nil)
    }
    @IBOutlet weak var CancelBtn: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        city = "undefined"
        country = "undefined"
        self.titleTextField.delegate = self


        self.hideKeyboardWhenTappedAround()

        map.delegate = self
        centerMap()
        
        tagsTextField.greyDesign()
        titleTextField.greyDesign()
        
    }
    
    func storeLocation() {
        let parameters: Parameters = [
            "description":descriptionTextView.text!,
            "name":titleTextField.text ?? "",
            "longitude": longitude!,
            "latitude": latitude!,
            "image":imageName!,
            "city": city!,
            "country":country!
        ]
        let url = Constants.url+"spots"
        let _headers : HTTPHeaders = [
            "Content-Type":"application/x-www-form-urlencoded",
            "Authorization":UserDefaults.standard.string(forKey: "token")!
            
        ]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: _headers).responseJSON{
            response in
            
            switch response.result {
            case .success:
                let jsonResponse = response.result.value as! [String:Any]
                if(response.response?.statusCode == 200){
                    print("Spot subido")
                    print(jsonResponse["message"]!)
                    self.performSegue(withIdentifier: "unwindToFeed", sender: nil)
                    return
                    
                } else {
                    let alert = UIAlertController(title: "Error", message: (jsonResponse["message"]! as! String), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                    print("error")
                }
            case .failure(let error):
                let alert = UIAlertController(title: "Ups! Something was wrong", message:
                    "Pls, try it later", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Settings", style:
                    .default, handler: { (accion) in
                        UIApplication.shared.open(URL.init(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
                }))
                alert.addAction(UIAlertAction(title: "ok :(", style:
                    .cancel, handler: { (accion) in }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func uploadPhotoRequest(){
        let image = self.image
        let imgData = UIImageJPEGRepresentation(image!, 1)
        let url = Constants.url+"img"
        print(url)
        let headers: HTTPHeaders = [
            "Authorization":UserDefaults.standard.string(forKey: "token")!,
            "Content-type": "multipart/form-data"
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(imgData!, withName: "img", fileName: self.imageName!+".png", mimeType: "image/png")
            
            print(self.imageName!+".png")
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                    if(response.response?.statusCode == 200){
                        print("Foto subida")
                        self.storeLocation()
                        return
                    }
                    
                }
            case .failure(let error):
                let alert = UIAlertController(title: "Ups! Something was wrong", message:
                    "Pls, try it later", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Settings", style:
                    .default, handler: { (accion) in
                        UIApplication.shared.open(URL.init(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
                }))
                alert.addAction(UIAlertAction(title: "ok :(", style:
                    .cancel, handler: { (accion) in }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    

    // Valida los datos.
    func validateInputs() -> Bool
    {
        if ((titleTextField.text?.isEmpty)! || (descriptionTextView.text?.isEmpty)!)
        {
            let alert = UIAlertController(title: "There cannot be empty fields", message:
                "Try it again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style:
                .cancel, handler: { (accion) in}))
            present(alert, animated: true, completion: nil)
            return false
        }
        if titleTextField.text!.count < 4 || titleTextField.text!.count > 30 {
            let alert = UIAlertController(title: "Invalid inputs", message:
                "Title size must be between 4 and 30 characters", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style:
                .cancel, handler: { (accion) in}))
            present(alert, animated: true, completion: nil)
            return false
        }
        if descriptionTextView.text!.count < 10 || descriptionTextView.text!.count > 300 {
            let alert = UIAlertController(title: "Invalid inputs", message:
                "Descriptions must content between 10 and 300 characters", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style:
                .cancel, handler: { (accion) in}))
            present(alert, animated: true, completion: nil)
            return false
        }
        if (longitude == nil || latitude == nil)
        {
            let alert = UIAlertController(title: "error in coordenates", message:
                "Try it again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style:
                .cancel, handler: { (accion) in}))
            present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func centerMap(){
       let coordinates = CLLocationCoordinate2D.init(latitude: self.latitude!, longitude: self.longitude!)// Establece las coordenadas del pin.
        let mark = PinAnnotation(pinTitle: titleTextField.text!, pinSubTitle: "", location: coordinates, id:0)           // Crea el marcador
        map.addAnnotation(mark)
        
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinates, span: span)
        map.setRegion(region, animated: true)
    }
    
    @IBAction func createBtn(_ sender: UIButton) {
        if  validateInputs() && Connectivity.isLocationEnabled() && Connectivity.isConnectedToInternet(){
            self.uploadPhotoRequest()
        }
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customannotaion") //Crea una vista personalizada del pin.
        
        annotationView.isEnabled = true // Activa el marcador.
        annotationView.canShowCallout = true // Establece si puede mostrar informacion extra en la burbuja
        annotationView.image = UIImage(named: "pin_full") // Establece la imagen del pin.
        annotationView.centerOffset = CGPoint(x:0, y:(annotationView.image!.size.height / -2));
        print("centra")
        
        
        return annotationView
    }
    
    //Esta función se encarga de ocultar el teclado
    @IBAction func textExit(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
}
