import UIKit
import Alamofire
class RecoverPasswordViewController: UIViewController {

    @IBOutlet weak var emailFieldRP: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var recoverPasswordBtn: UIButton!
    @IBAction func actionRecoverPassword(_ sender: Any) {
        requestRegister()
    }
    
    func requestRegister()
    {
        request("http://192.168.6.162/api/public/index.php/api/forgotPass",
                method: .post,
                parameters: ["email":emailFieldRP.text!],
                encoding: URLEncoding.httpBody).responseJSON { (replyQuestR) in
                    print(replyQuestR.response?.statusCode ?? 0)
                    print(replyQuestR.result.value!)
                    
                    var Respuesta = replyQuestR.result.value as! [String:Any]
                    
                    if((replyQuestR.response?.statusCode) != 200)
                    {
                        let alert = UIAlertController(title: "\(Respuesta["message"] ?? "default") ", message:
                            "Try it again", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "ok", style:
                            .cancel, handler: { (accion) in}))
                        self.present(alert, animated: true, completion: nil)
                    }
        }
    }
    
    @IBAction func exitText(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
}
