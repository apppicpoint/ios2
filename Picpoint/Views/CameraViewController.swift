
import UIKit
import AVFoundation

class CameraViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var image: UIImage?
    var imageName: String?
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
            imagePicker.allowsEditing = true //Permite editar la foto
            self.present(imagePicker, animated: true, completion: nil)//Reserva la foto para usarla.
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //Coge la imagen
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.image = pickedImage // Coloca la imagen en el imageView
            let URIphoto = utils.randomString(length: 15) // Le da un nombre aleatorio
            imageName = UserDefaults.standard.string(forKey: "user_id")! + utils.randomString(length: 15)

           
        }
        dismiss(animated: true, completion: nil) // Cierra la vista
        
        performSegue(withIdentifier: "previewImage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is previewImageViewController {
            
            let destination = segue.destination as! previewImageViewController
            destination.imageName = imageName
            destination.image = self.image!
        }
    }
    
    
    @IBAction func backFromNewSpot(_ segue: UIStoryboardSegue) {
        
        
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

    


