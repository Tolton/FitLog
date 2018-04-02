//
//  AddFoodView.swift
//  FitLog
//
//  Created by Jack on 2018-03-26.
//  Copyright © 2018 Jack. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import FirebaseDatabase
import FirebaseAuth

class AddFoodView: UIViewController {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    var ref: DatabaseReference!
    var searchDict = [String: String]()
    var thisArray = [String]()
    
    @IBAction func updateButton(_ sender: Any) {
        textView.text = ""
        var newArray = [String]()
        var tempArray = [String]()
        /* code used from https://stackoverflow.com/questions/25738817/removing-duplicate-elements-from-an-array?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa */
        //This removes duplicates while keeping the array order
        for item in thisArray {
            if !tempArray.contains(item) {
                newArray.append(item)
                tempArray.append(item)
            }
        }
        
        textView.text = ""
        for thing in newArray {
            textView.text = textView.text + thing + "\n"
        }
        thisArray = newArray
    }
    
    @IBAction func searchFoodButton(_ sender: Any) {
        let inputStr = searchTextField.text
        thisArray.removeAll()
        let urlInputStr = inputStr?.replacingOccurrences(of: " ", with: "%20")
        let url = URL(string: "https://api.edamam.com/api/food-database/parser?ingr="+urlInputStr!+"&app_id=5f52aa67&app_key=5a970d50e3c500a4e4450ec8d7394a4e&page=0")
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                if let urlContent = data {
                    
                    let jsonResult = try? JSONSerialization.jsonObject(with: urlContent, options: []) as! NSDictionary
                    
                    //gets the food name and the ui
                    let foodLabel = String(describing: jsonResult?.value(forKeyPath: "hints.food.label"))
                    let foodUri = String(describing: jsonResult?.value(forKeyPath: "hints.food.uri"))
                    //clean up the strings and split them up
                    let foodLabelComma = foodLabel.replacingOccurrences(of: ",", with: "")
                    var foodLabelSplit = foodLabelComma.components(separatedBy: "\n")
                    foodLabelSplit.remove(at: 0)
                    let foodUriComma = foodUri.replacingOccurrences(of: ",", with: "")
                    var foodUriSplit = foodUriComma.components(separatedBy: "\n")
                    foodUriSplit.remove(at: 0)
                    //create a dictionary from the values
                    for i in 0..<foodLabelSplit.count {
                        self.searchDict[foodLabelSplit[i]] = foodUriSplit[i]
                        self.thisArray.append(foodLabelSplit[i])
                    }
                }
            }
        }
        
        task.resume()
        
        
    }
    @IBAction func cancelAddButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        if thisArray.count != 0 {
            //get the current date
            let date = Date()
            let formatDate = DateFormatter()
            formatDate.dateFormat = "dd-MM-yyyy"
            let thisDate = formatDate.string(from: date)
            
            //json data to post
            let foodUri = searchDict[thisArray[0]]
            
            let data: [String: Any] = ["quantity": 1,
                                       "measureURI": "http://www.edamam.com/ontologies/edamam.owl#Measure_unit",
                                       "foodURI": foodUri!]//this will be the selected item
            let parameters: [String: Any] =
                ["yield": 1,
                 "ingredients": [data]]
            
            let getFoodUrl = "https://api.edamam.com/api/food-database/nutrients?app_id=5f52aa67&app_key=5a970d50e3c500a4e4450ec8d7394a4e"
            
            Alamofire.request(getFoodUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseString { response in
                //check to make sure the request went through correctly
                if let result = response.result.value {
                    if let data = result.data(using: .utf8) {
                        
                        //puts the response as a dictionary
                        let json = try? JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
                        let foodCals = json!["calories"] as! Int
                        //gets the food name
                        let foodDetails = String(describing: json?.value(forKeyPath: "ingredients.parsed.food"))
                        
                        var count = 0
                        var foodName = ""
                        //zPut the food name into a string
                        for c in foodDetails {
                            if c == "(" || c == ")" {
                                count = count + 1
                            } else if count == 3 {
                                foodName = foodName + String(c)
                            }
                        }
                        //foodName = foodName.replacingOccurrences(of: " ", with: "")
                        foodName = foodName.replacingOccurrences(of: "/", with: "")
                        foodName = foodName.replacingOccurrences(of: ",", with: "")
                        foodName = foodName.replacingOccurrences(of: "\n", with: "")
                        print(foodName)
                        print(foodCals)
                        
                        //Update the current foods
                        self.ref.updateChildValues(["\(userID!)/\(thisDate)/\(foodName)": "\(foodCals)"])
                        
                        
                        self.ref.child(userID!).child(thisDate).observeSingleEvent(of: .value, with: { (snapshot) in
                            // Get user value
                            let value = snapshot.value as? NSDictionary
                            if value != nil {
                                let currCalories = value?["Food"] as? String ?? ""
                                let newCals = Int(currCalories)! + foodCals
                                self.ref.updateChildValues(["\(userID!)/\(thisDate)/Food": "\(newCals)"])
                            }
                        }) { (error) in
                            print(error.localizedDescription)
                        }
                        
                    }
                }
                
                
            }
            dismiss(animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

