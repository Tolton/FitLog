//
//  ViewController.swift
//  FitLog
//
//  Created by Jack on 2018-03-21.
//  Copyright © 2018 Jack. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import os.log


class HomeView: UIViewController, UITextViewDelegate {


    @IBOutlet weak var caloriesTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var stepsTextField: UITextField!
    @IBOutlet weak var caloriesTextView: UITextView!
    @IBOutlet weak var weightTextView: UITextView!
    @IBOutlet weak var stepsTextView: UITextView!
    var ref: DatabaseReference!
    var refHandle: DatabaseHandle!
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.isEditable = false
        if textView == caloriesTextView {
            self.performSegue(withIdentifier: "caloriesViewSegue", sender: Any?.self)
        } else if textView == weightTextView {
            self.performSegue(withIdentifier: "weightViewSegue", sender: Any?.self)
        } else if textView == stepsTextView {
            self.performSegue(withIdentifier: "stepsViewSegue", sender: Any?.self)
        }
        textView.isEditable = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated:true)
        caloriesTextView.layer.borderWidth = 1
        weightTextView.layer.borderWidth = 1
        stepsTextView.layer.borderWidth = 1
        
        let userID = Auth.auth().currentUser?.uid
        ref = Database.database().reference()
        
        let date = Date()
        let formatDate = DateFormatter()
        formatDate.dateFormat = "dd-MM-yyyy"
        let thisDate = formatDate.string(from: date)
        
        //Checks if the user has logged any for today, if not then creates them with default 0 values, then assignes the text fields a value one time only
        ref.child(userID!).child(thisDate).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            if value == nil {
                //setup the database
                let data = ["Weight": "0",
                            "Steps": "0",
                            "Food": "0"] as [String : Any]
                self.ref.updateChildValues(["\(userID!)/\(thisDate)/": data])
                self.weightTextField.text = "Not Logged"
                self.stepsTextField.text = "0"
                self.caloriesTextField.text = "0"
            } else {
                let currSteps = value?["Steps"] as? String ?? ""
                let currWeight = value?["Weight"] as? String ?? ""
                let currCalories = value?["Steps"] as? String ?? ""
                self.weightTextField.text = currWeight
                self.stepsTextField.text = currSteps
                self.caloriesTextField.text = currCalories
                
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        refHandle = ref.child(userID!).child(thisDate).observe(.childChanged, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as! String
            //check which child was changed
            if snapshot.key == "Weight" {
                self.weightTextField.text = value
            } else if snapshot.key == "Steps" {
                self.stepsTextField.text = value
            } else {
                self.caloriesTextField.text = value
            }
           
            print("\(value)")
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

