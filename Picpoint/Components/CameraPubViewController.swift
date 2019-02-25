//
//  CameraPubViewController.swift
//  Picpoint
//
//  Created by alumnos on 25/2/19.
//  Copyright © 2019 Joaquín Collazo Ruiz. All rights reserved.
//

import UIKit
import AVFoundation

class CameraPubViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var image: UIImage?
    var imageName: String?
    let utils = Utils()
    var imagePicker = UIImagePickerController() //Selector de imagenes para la galería
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func goPreviewImage(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "previewImage2", sender: sender)
    }
    
    
    @IBAction func takePhotoButton(_ sender: UIButton) {
        performSegue(withIdentifier: "previewImage2", sender: sender)
    }
    // Do any additional setup after loading the view.
    @IBAction func takePhotoFromGallery(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self //Selecciona la propia vista como delegado
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false //Permite editar la foto
            self.present(imagePicker, animated: true, completion: nil)//Reserva la foto para usarla.
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.image = image // Coloca la imagen en el imageView
            imageName = UserDefaults.standard.string(forKey: "user_id")! + utils.randomString(length: 15)
        }
        //dismiss(animated: true, completion: nil) // Cierra la vista
        performSegue(withIdentifier: "previewImage2", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is PreviewImagePubViewController {
            let destination = segue.destination as! PreviewImagePubViewController
            
            print(imageName , "en prepare clase CameraViewController")
            print(image , "en prepare clase CameraViewController")
            
            destination.imageName = imageName
            destination.image = self.image!
        }
    }
    
    
    @IBAction func backFromNewPubToCamera(_ segue: UIStoryboardSegue) {
        
    }
    
}





