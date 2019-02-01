import UIKit
import Alamofire
import SystemConfiguration
import Foundation

class RegisterViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var nickNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    let validator = Validator()
    override func viewDidLoad() {super.viewDidLoad()}
    
    
    @IBAction func register(_ sender: Any){
        if validateInputs()
        {
            requestRegister()
        }
    }
    //Botón de usuario sin registrarse
    @IBAction func enterWithoutRegistration(_ sender: Any) {
        requestGuestLogin()
    }
    //Peticion con la api para usuario sin registro
    func requestGuestLogin()
    {
        if Connectivity.isConnectedToInternet() {
            request(Constants.url+"guest",
                method: .post,
                encoding: URLEncoding.httpBody).responseJSON { (replyQuestGL) in
                    print(replyQuestGL.response?.statusCode ?? 0)
                    
                    var jsonResponse = replyQuestGL.result.value as! [String:Any]

                    if((replyQuestGL.response?.statusCode) != 200)
                    {
                        let alert = UIAlertController(title: "\(jsonResponse["message"] ?? "default") ", message:
                            "Try it again", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "ok", style:
                            .cancel, handler: { (accion) in}))
                        self.present(alert, animated: true, completion: nil)
                    }
                    if replyQuestGL.result.isSuccess
                    {
                        print(replyQuestGL.result.value!)
                        UserDefaults.standard.set(jsonResponse["token"]!, forKey: "token")
                        UserDefaults.standard.set(jsonResponse["role_id"]!, forKey: "role_id")
                        print(UserDefaults.standard.string(forKey: "token")!)
                        self.performSegue(withIdentifier: "registerOK", sender: nil)
                    }
            }
        }else{
            let alert = UIAlertController(title: "No connection", message:
                "Try it again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: { (accion) in}))
            present(alert, animated: true, completion: nil)
        }
    }
    
    //Petición con la api del registro
    func requestRegister()
    {
        if Connectivity.isConnectedToInternet() {
            print("ONLINE")
            request(Constants.url+"register",
                    method: .post,
                    parameters: ["name":nameField.text!, "email":emailField.text!, "password":passwordField.text! , "nickName":nickNameField.text!],
                    encoding: URLEncoding.httpBody).responseJSON { (replyQuestR) in
                        print(replyQuestR.response?.statusCode ?? 0)
                        
                        var jsonResponse = replyQuestR.result.value as! [String:Any]
                        
                        if (replyQuestR.error != nil){
                        }
                        if replyQuestR.response?.statusCode == 200
                        {
                            UserDefaults.standard.set(jsonResponse["token"]!, forKey: "token")
                            UserDefaults.standard.set(jsonResponse["user_id"]!, forKey: "user_id")
                            UserDefaults.standard.set(jsonResponse["role_id"]!, forKey: "role_id")

                            self.performSegue(withIdentifier: "registerOK", sender: nil)
                        }
                        
                        if((replyQuestR.response?.statusCode) != 200)
                        {
                            let alert = UIAlertController(title: "\(jsonResponse["message"] ?? "An error ocurred") ", message:
                                "Try it again", preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "ok", style:
                                .cancel, handler: { (accion) in}))
                            self.present(alert, animated: true, completion: nil)
                        }
            }
        }else{
            let alert = UIAlertController(title: "No connection", message:
                "Try it again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: { (accion) in}))
            present(alert, animated: true, completion: nil)
        }
        
    }
   
   
    
    //Esta función se encarga de ocultar el teclado
    @IBAction func textExit(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    // Valida los datos
    func validateInputs() -> Bool
    {
        if ((emailField.text?.isEmpty)! || (passwordField.text?.isEmpty)! || (nickNameField.text?.isEmpty)!)        {
            let alert = UIAlertController(title: "There can be no empty fields", message:
                "Try it again", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "ok", style:
                .cancel, handler: { (accion) in}))
            present(alert, animated: true, completion: nil)
            return false
        }
        if !validator.isValidPassword(string: passwordField.text!){
            let alert = UIAlertController(title: "Invalid password", message:
                "8 - 16 caracters length and at least one letter and one number", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style:
                .cancel, handler: { (accion) in}))
            present(alert, animated: true, completion: nil)
            return false
        }
        if !validator.isValidNickName(string: nickNameField.text!){
            let alert = UIAlertController(title: "Invalid nick", message:
                "3 - 16 characters length. Don't use special characters", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style:
                .cancel, handler: { (accion) in}))
            present(alert, animated: true, completion: nil)
            return false
        }
        if passwordField.text != confirmPasswordField.text
        {
            let alert = UIAlertController(title: "Passwords don´t match", message:
                "Try it again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: { (accion) in}))
            present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
}
