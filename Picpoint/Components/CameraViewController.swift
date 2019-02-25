
import UIKit
import AVFoundation

class CameraViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var image: UIImage?
    var imageName: String?
    var longitude: Double?
    var latitude: Double?
    let utils = Utils()
    var imagePicker = UIImagePickerController() //Selector de imagenes para la galería
    /*
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    */
    
    override func viewDidLoad() {
        
        /*
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession() */
        
    }

    @IBAction func goPreviewImage(_ sender: UIBarButtonItem) {
        do {
        performSegue(withIdentifier: "previewImage", sender: sender)
        } catch {
        performSegue(withIdentifier: "previewImage2", sender: sender)
        }
    }
    
    
    @IBAction func takePhotoButton(_ sender: UIButton) {
        performSegue(withIdentifier: "previewImage", sender: sender)
        do {
        performSegue(withIdentifier: "previewImage", sender: self)
        } catch {
        performSegue(withIdentifier: "previewImage2", sender: self)
        }
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
        do {
            performSegue(withIdentifier: "previewImage", sender: self)
        } catch {
            performSegue(withIdentifier: "previewImage2", sender: self)
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is PreviewImageViewController {
            let destination = segue.destination as! PreviewImageViewController
            
            print(imageName , "en prepare clase CameraViewController")
            print(image , "en prepare clase CameraViewController")
            
            destination.imageName = imageName
            destination.image = self.image!
            
            if segue.identifier == "previewImage" {
                destination.longitude = longitude
                destination.latitude = latitude
            }
            
            
        }
    }
    
    
    @IBAction func backFromNewSpotToCamera(_ segue: UIStoryboardSegue) {        
        
    }
    
/*
    func setupCaptureSession(){
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
    }
    
    func setupDevice(){
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices
        
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device

                print("back")

                
            } else if device.position == AVCaptureDevice.Position.front{
                frontCamera = device
                print("front")
            }
        }
        
        currentCamera = backCamera
    }
    
    func setupInputOutput(){
        do{
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSession.addInput(captureDeviceInput)
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
        } catch {
            print(error)
        }
        
    }
    
    func setupPreviewLayer(){
        
        
    }
    
    func startRunningCaptureSession(){
        
        
    }
 */
}

    


