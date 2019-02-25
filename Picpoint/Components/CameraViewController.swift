
import UIKit
import AVFoundation

class CameraViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var image: UIImage?
    var imageName: String?
    var longitude: Double?
    var latitude: Double?
    let utils = Utils()
    var imagePicker = UIImagePickerController() //Selector de imagenes para la galería

    override func viewDidLoad() {
 
    }

    @IBAction func goPreviewImage(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "previewImage", sender: sender)
    }
    
    
    @IBAction func takePhotoButton(_ sender: UIButton) {
        performSegue(withIdentifier: "previewImage", sender: sender)
    }
    
    
    
    // Do any additional setup after loading the view.
    @IBAction func takePhotoFromGalelery(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self //Selecciona la propia vista como delegado
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false //Permite editar la foto
            self.present(imagePicker, animated: true, completion: nil)//Reserva la foto para usarla.
        }
    }
    
    //Coge la foto
    func imagePickerController(_ picker: UIImagePickerController,
                                       didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.image = image // Coloca la imagen en el imageView
            imageName = UserDefaults.standard.string(forKey: "user_id")! + utils.randomString(length: 15)
        }
        //dismiss(animated: true, completion: nil) // Cierra la vista
        performSegue(withIdentifier: "previewImage", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is PreviewImageViewController {
            let destination = segue.destination as! PreviewImageViewController
            
            print(imageName! , "en prepare clase CameraViewController")
            print(image! , "en prepare clase CameraViewController")
            
            destination.imageName = imageName
            destination.image = self.image!
            destination.longitude = longitude
            destination.latitude = latitude
        }
    }
    
    
    @IBAction func backFromNewSpotToCamera(_ segue: UIStoryboardSegue) {        
        
    }
}

    


