//
//  registerController.swift
//  FitLog
//
//  Created by Jack on 2018-03-30.
//  Copyright © 2018 Jack. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class registerController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordCheckTextField: UITextField!
    @IBAction func registerButton(_ sender: UIButton) {
        if passwordTextField.text == passwordCheckTextField.text {
            Auth.auth().createUser(withEmail: usernameTextField.text!, password: passwordTextField.text!) {
            (user, error) in
                if user != nil {
                    var ref: DatabaseReference!
                    let userID = user!.uid
                    
                    let date = Date()
                    let formatDate = DateFormatter()
                    formatDate.dateFormat = "dd,MM,yyyy"
                    let thisDate = formatDate.string(from: date)
                    
                    
                    ref = Database.database().reference()
                    
                    //setup the database
                    let data = ["Weight": "0",
                                "Steps": "0",
                                "Food": "0"] as [String : Any]
                    ref.child("\(userID)/").setValue(thisDate)
                    ref.child("\(userID)/\(thisDate)/").setValue(data)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
