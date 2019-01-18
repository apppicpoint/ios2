import UIKit
import Alamofire

class LoginViewController: UIViewController {

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var emailFieldL: UITextField!
    @IBOutlet weak var passwordFieldL: UITextField!
    
    override func viewDidLoad() {super.viewDidLoad()}
    
    @IBAction func login(_ sender: Any) {
        emailValidation()
        loginLogic()
    }
    
    func requestLogin()
    {
        request("http://192.168.6.162/api/public/index.php/api/login",
                method: .post,
                parameters: ["email":emailFieldL.text!, "password":passwordFieldL.text!],
                encoding: URLEncoding.httpBody).responseJSON { (respuesta) in
                    print(respuesta.response?.statusCode ?? 0)
                    print(respuesta.result.value!)

                    if((respuesta.response?.statusCode) != 200)
                    {
                        let alert = UIAlertController(title: "\(respuesta.result.value ?? "email") ", message:
                            "Try it again", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "ok", style:
                            .cancel, handler: { (accion) in}))
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    if((respuesta.response?.statusCode) == 200)
                    {
                        self.performSegue(withIdentifier: "loginOK", sender: nil)
                    }
        }
    }
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
    
    
}
