//
//  stepsDisplayView.swift
//  FitLog
//
//  Created by Jack on 2018-03-28.
//  Copyright © 2018 Jack. All rights reserved.
//

import UIKit


class stepsDisplayView: UIViewController {
    
    @IBOutlet weak var stepsTextField: UITextField!
    
    @IBAction func stepsAddButton(_ sender: Any) {
        stepsTextField.text = ""
        //store in backend
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
