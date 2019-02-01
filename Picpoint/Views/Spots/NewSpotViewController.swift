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
class NewSpotViewController: UIViewController {

    var image: UIImage?
    var imageName: String?
    var longitude: Double?
    var latitude: Double?
    var city: String?
    var country: String?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    let utils = Utils()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        city = "Madrid"
        country = "España"
        longitude = 23
        latitude = 2
        
        
    }
    
    @IBAction func saveSpot(_ sender: UIBarButtonItem) {
        if  validateInputs() {
            storeLocation()
            uploadPhotoRequest()
        }
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
                    return
                    
                } else {
                    let alert = UIAlertController(title: "Error", message: (jsonResponse["message"]! as! String), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                    print("error")
                }
                
            case .failure(let error):
                print("Sin conexión")
                print(error)
            }
        }
    }
    
    func uploadPhotoRequest(){
        
        let image = self.image
        let imgData = image!.jpegData(compressionQuality: 1)
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
                    print(response.response!.statusCode)
                    if(response.response?.statusCode == 200){
                        print("Foto subida")
                        return
                    }
                }
            case .failure(let error):
                print("Sin conexión")
                print(error)
            }
        }
    }
    

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
                "Title size must be between 10 and 300 characters", preferredStyle: .alert)
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
    
    
}
