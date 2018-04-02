//
//  loginController.swift
//  FitLog
//
//  Created by Jack on 2018-03-30.
//  Copyright © 2018 Jack. All rights reserved.
//

import UIKit
import FirebaseAuth
import Alamofire

class loginController: UIViewController {

    @IBOutlet weak var passView: UITextView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBAction func loginButton(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: usernameField.text!, password: passwordField.text!) { (user, error) in
            // ...
            if user != nil {
                self.performSegue(withIdentifier: "loginSuccess", sender: Any?.self)
            } else {
                self.passView.isHidden = false
                self.passView.text = "You entered incorrect information, please try again."
            }
        }
        
    }
    
    @IBAction func registerButton(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        passView.isHidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
