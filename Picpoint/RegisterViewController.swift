import UIKit
import Alamofire

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var nickNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var registerBtn: UIButton!

    override func viewDidLoad() {super.viewDidLoad()}
    
    @IBAction func register(_ sender: Any){
        emptyFields()
        checkPassword()
        checkLengthPassword()
        emailValidation()
        registerLogic()
    }
    
    func requestRegister()
    {
        request("http://192.168.6.162/api/public/index.php/api/register",
                method: .post,
                parameters: ["name":nameField.text!, "email":emailField.text!, "password":passwordField.text! , "nickName":nickNameField.text!],
                encoding: URLEncoding.httpBody).responseJSON { (respuesta) in
                    print(respuesta.response?.statusCode ?? 0)
                    print(respuesta.result.value!)
                    
                    if((respuesta.response?.statusCode) != 200)
                    {
                        let alert = UIAlertController(title: "An error ocurred", message:
                            "Plis try it again", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "ok", style:
                            .cancel, handler: { (accion) in}))
                        self.present(alert, animated: true, completion: nil)
                    }
        }
    }
    
    
    func registerLogic()
    {
            if registerBtn.isTouchInside && (!(nameField.text?.isEmpty)!) && (!(nickNameField.text?.isEmpty)!) && (!(emailField.text?.isEmpty)!)  && (!(passwordField.text?.isEmpty)!) && (!(confirmPasswordField.text?.isEmpty)!)
            {
                requestRegister()
                let alert = UIAlertController(title: "Thank you for registering \(nickNameField.text ?? "nickName") ", message:
                    "we hope you enjoy the app", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "ok", style:
                    .cancel, handler: { (accion) in
                        self.performSegue(withIdentifier: "registerOK", sender: nil)

                }))
                present(alert, animated: true, completion: nil)
            }
    }
    
    func checkPassword()
    {
        if passwordField.text != confirmPasswordField.text
        {
            let alert = UIAlertController(title: "Passwords don´t match", message:
                "Try it again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: { (accion) in}))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func checkLengthPassword()
    {
        if (passwordField.text?.count)! < 8
        {
            let alert = UIAlertController(title: "Password must be at least 8 characters long", message:
                "Try it again", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "ok", style:
                .cancel, handler: { (accion) in}))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func emptyFields()
    {
        if ((nameField.text?.isEmpty)! && (nickNameField.text?.isEmpty)! && (emailField.text?.isEmpty)! && (passwordField.text?.isEmpty)! && (confirmPasswordField.text?.isEmpty)!)
        {
            let alert = UIAlertController(title: "There can be no empty fields", message:
                "Try it again", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "ok", style:
                .cancel, handler: { (accion) in}))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func emailValidation()
    {
        if (!(emailField.text?.contains("@"))!)
        {
            let alert = UIAlertController(title: "The mail must contain @", message:
                "Try it again", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "ok", style:
                .cancel, handler: { (accion) in}))
            present(alert, animated: true, completion: nil)
        }
    }
    
}
