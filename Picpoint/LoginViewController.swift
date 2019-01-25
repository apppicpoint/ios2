import UIKit
import Alamofire

class LoginViewController: UIViewController {

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var emailFieldL: UITextField!
    @IBOutlet weak var passwordFieldL: UITextField!
    
    override func viewDidLoad() {super.viewDidLoad()}
    //Botón de login
    @IBAction func login(_ sender: Any) {
        emptyFields()
        emailValidation()
        checkLengthPassword()
        loginLogic()
    }
    //Botón de usuario sin registro
    @IBAction func enterWithoutRegistration(_ sender: Any) {
        requestGuest()
    }
    //Petición con la api
    func requestLogin()
    {
        if Connectivity.isConnectedToInternet() {
            request("http://192.168.6.162/api/public/index.php/api/login",
                    method: .post,
                    parameters: ["email":emailFieldL.text!, "password":passwordFieldL.text!],
                    encoding: URLEncoding.httpBody).responseJSON { (replyQuestL) in
                        print(replyQuestL.response?.statusCode ?? 0)
                        print(replyQuestL.result.value!)

                        var ResponseL = replyQuestL.result.value as! [String:Any]
                        
                        if((replyQuestL.response?.statusCode) != 200)
                        {
                            let alert = UIAlertController(title: "\(ResponseL["message"] ?? "email") ", message:
                                "Try it again", preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "ok", style:
                                .cancel, handler: { (accion) in}))
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                        if((replyQuestL.response?.statusCode) == 200)
                        {
                            saveInDefaults(value: ResponseL["token"] as! String, key: "token")
                            print(loadFromDefaults(key: "token"))
                            self.performSegue(withIdentifier: "loginOK", sender: nil)
                        }
            }
        }else{
            let alert = UIAlertController(title: "No connection", message:
                "Try it again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: { (accion) in}))
            present(alert, animated: true, completion: nil)
        }
    }
    //Petición del usuario sin registro
    func requestGuest()
    {
        if Connectivity.isConnectedToInternet() {
            request("http://192.168.6.162/api/public/index.php/api/guest",
                    method: .post,
                    encoding: URLEncoding.httpBody).responseJSON { (replyQuestGLL) in
                        print(replyQuestGLL.response?.statusCode ?? 0)
    //                    print(replyQuestGL.result.value!)
                        
                        var ResponseGLL = replyQuestGLL.result.value as! [String:Any]
                        
                        if((replyQuestGLL.response?.statusCode) != 200)
                        {
                            let alert = UIAlertController(title: "\(ResponseGLL["message"] ?? "default") ", message:
                                "Try it again", preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "ok", style:
                                .cancel, handler: { (accion) in}))
                            self.present(alert, animated: true, completion: nil)
                        }
                        if replyQuestGLL.result.isSuccess
                        {
                            print(replyQuestGLL.result.value!)
                            saveInDefaults(value: ResponseGLL["token"] as! String, key: "token")
                            print(loadFromDefaults(key: "token"))
                            self.performSegue(withIdentifier: "loginOK", sender: nil)
                        }
            }
        }else{
            let alert = UIAlertController(title: "No connection", message:
                "Try it again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: { (accion) in}))
            present(alert, animated: true, completion: nil)
        }
    }
    //requisitos básicos del login
    func loginLogic()
    {
        if loginBtn.isTouchInside && (!(emailFieldL.text?.isEmpty)!) && (!(passwordFieldL.text?.isEmpty)!)
        {
            requestLogin()
        }
            else
            {
                let alert = UIAlertController(title: "We have not been able to login with the email:  \(emailFieldL.text ?? "email") ", message:
                    "Try it again", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "ok", style:
                    .cancel, handler: { (accion) in
                        print("a")
                }))
                present(alert, animated: true, completion: nil)
                
            }
        }
    //Esta función obliga a poner @ en el mail
    func emailValidation()
    {
        if (!(emailFieldL.text?.contains("@"))!)
        {
            let alert = UIAlertController(title: "The mail must contain @", message:
                "Try it again", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "ok", style:
                .cancel, handler: { (accion) in}))
            present(alert, animated: true, completion: nil)
        }
    }
    func emptyFields()
    {
        if ((emailFieldL.text?.isEmpty)! && (passwordFieldL.text?.isEmpty)!)
        {
            let alert = UIAlertController(title: "There can be no empty fields", message:
                "Try it again", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "ok", style:
                .cancel, handler: { (accion) in}))
            present(alert, animated: true, completion: nil)
        }
        if ((emailFieldL.text?.isEmpty)!)
        {
            let alert = UIAlertController(title: "There can be no empty fields", message:
                "Try it again", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "ok", style:
                .cancel, handler: { (accion) in}))
            present(alert, animated: true, completion: nil)
        }
        if ((passwordFieldL.text?.isEmpty)!)
        {
            let alert = UIAlertController(title: "There can be no empty fields", message:
                "Try it again", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "ok", style:
                .cancel, handler: { (accion) in}))
            present(alert, animated: true, completion: nil)
        }
    }
    func checkLengthPassword()
    {
        if (passwordFieldL.text?.count)! < 8
        {
            let alert = UIAlertController(title: "Password must be at least 8 characters long", message:
                "Try it again", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "ok", style:
                .cancel, handler: { (accion) in}))
            present(alert, animated: true, completion: nil)
        }
    }
    //Esta función se encarga de ocultar el teclado
    @IBAction func textExit(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
}
