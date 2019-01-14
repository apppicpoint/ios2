import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var nickNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var registerBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func registerLogic(){
        
        if registerBtn.isTouchInside && (!(emailField.text?.isEmpty)!) && (!(nameField.text?.isEmpty)!) && (!(passwordField.text?.isEmpty)!)
        {
            
            let alert = UIAlertController(title: "Thank you for registering \(nameField.text ?? "nameUser") ", message:
                "we hope you enjoy the app", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "ok", style:
                .cancel, handler: { (accion) in
                    nameRegister.append(self.emailField.text!)
                    emailRegister.append(self.nameField.text!)
                    passwordRegister.append(self.passwordField.text!)
            }))
            present(alert, animated: true, completion: nil)

        }
        
    }

    @IBAction func register(_ sender: Any) {
        registerLogic()
    }
    
}
