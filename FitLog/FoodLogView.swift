//
//  FoodLogView.swift
//  FitLog
//
//  Created by Jack on 2018-03-26.
//  Copyright © 2018 Jack. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class FoodLogView: UIViewController {
    
    @IBOutlet weak var caloriesView: UITextField!
    @IBOutlet weak var dateView: UITextField!
    @IBOutlet weak var foodLogView: UITextView!
    var ref: DatabaseReference!
    var refHandle: DatabaseHandle!
    //func sendToLog(_ display:Food)
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userID = Auth.auth().currentUser?.uid
        ref = Database.database().reference()
        //get the current date
        let date = Date()
        let formatDate = DateFormatter()
        formatDate.dateFormat = "dd-MM-yyyy"
        let thisDate = formatDate.string(from: date)
        dateView.text = thisDate
        ref.child(userID!).child(thisDate).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let newSnap = snapshot.value as? NSDictionary
            if newSnap == nil {
            } else {
                let currCalories = newSnap?["Food"] as? String ?? ""
                self.caloriesView.text = self.caloriesView.text! + " " + currCalories
                for (key, value) in newSnap! {
                    if String(describing: key) != "Weight"  && String(describing: key) != "Food" && String(describing: key) != "Steps" {
                        self.foodLogView.text = self.foodLogView.text + String(describing: key) + "\t\t" + String(describing: value) + "\n"
                    }
                }
                //self.foodLogView.text = String(value!)
                
                
                
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
