import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var emailFieldL: UITextField!
    @IBOutlet weak var passwordFieldL: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func loginLogic(){
        
        if loginBtn.isTouchInside && (!(emailFieldL.text?.isEmpty)!) && (!(passwordFieldL.text?.isEmpty)!)
        {
            
            emailLogin.append(self.emailFieldL.text!)
            passwordLogin.append(self.passwordFieldL.text!)
            
            if (emailRegister.contains(emailFieldL.text!)) && (passwordRegister.contains(passwordFieldL.text!))
                && (emailRegister.firstIndex(of: emailFieldL.text!) != nil)
            {
                print("GG")
                let alert = UIAlertController(title: "Thank you for logging in", message:
                    "Let's hope you enjoy the app.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "ok", style:
                    .cancel, handler: { (accion) in
                        emailRegister.append(self.emailFieldL.text!)
                        passwordRegister.append(self.passwordFieldL.text!)
                        
                }))
                present(alert, animated: true, completion: nil)
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
    }
    @IBAction func login(_ sender: Any) {
        loginLogic()
    }
}
