//
//  AddFoodView.swift
//  FitLog
//
//  Created by Jack on 2018-03-26.
//  Copyright © 2018 Jack. All rights reserved.
//

import UIKit
import os.log

class AddFoodView: UIViewController {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    var food: Food?
    //var foodLogController: FoodLogView?
    
    
    @IBAction func cancelAddButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        //food = Food(searchTextField.text!, 0)
        //foodLogController?.sendToLog(food)
        dismiss(animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
