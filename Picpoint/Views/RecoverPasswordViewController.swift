import UIKit
import Alamofire
class RecoverPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailFieldRP: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var recoverPasswordBtn: UIButton!
    override func viewDidLoad() {super.viewDidLoad()}
    //Botón recuperar contraseña
    @IBAction func actionRecoverPassword(_ sender: Any) {
        emailValidation()
        requestRegister()
    }
    //Petición con la api de recuperación de contraseña
    func requestRegister()
    {
        if Connectivity.isConnectedToInternet() {
            request(Constants.url+"forgotPass",
                    method: .post,
                    parameters: ["email":emailFieldRP.text!],
                    encoding: URLEncoding.httpBody).responseJSON { (replyQuestR) in
                        
                        switch replyQuestR.result {
                        case .success:
                            var Respuesta = replyQuestR.result.value as! [String:Any]
                            if((replyQuestR.response?.statusCode) != 200)
                            {
                                let alert = UIAlertController(title: "\(Respuesta["message"] ?? "default") ", message:
                                    "Try it again", preferredStyle: .alert)
                                
                                alert.addAction(UIAlertAction(title: "ok", style:
                                    .cancel, handler: { (accion) in}))
                                self.present(alert, animated: true, completion: nil)
                            }
                        case .failure(let error):
                            let alert = UIAlertController(title: "Ups! Something was wrong", message:
                                "Pls, try it later", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Settings", style:
                                .default, handler: { (accion) in
                                    UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                            }))
                            alert.addAction(UIAlertAction(title: "ok :(", style:
                                .cancel, handler: { (accion) in }))
                            self.present(alert, animated: true, completion: nil)
                        }
            }
        }else{
            let alert = UIAlertController(title: "Pls! Activate the internet", message:
                "Picpoint cannot work without it", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Settings", style:
                .default, handler: { (accion) in
                    UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            }))
            alert.addAction(UIAlertAction(title: "ok :(", style:
                .cancel, handler: { (accion) in }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func emailValidation()
    {
        if (!(emailFieldRP.text?.contains("@"))!)
        {
            let alert = UIAlertController(title: "The mail must contain @", message:
                "Try it again", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "ok", style:
                .cancel, handler: { (accion) in}))
            present(alert, animated: true, completion: nil)
        }
    }
    //Esta función se encarga de ocultar el teclado
    @IBAction func exitText(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
}
