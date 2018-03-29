//
//  ViewController.swift
//  FitLog
//
//  Created by Jack on 2018-03-21.
//  Copyright © 2018 Jack. All rights reserved.
//

import UIKit
import os.log

class HomeView: UIViewController, UITextViewDelegate {


    @IBOutlet weak var caloriesTextView: UITextView!
    @IBOutlet weak var weightTextView: UITextView!
    @IBOutlet weak var stepsTextView: UITextView!
    
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
        caloriesTextView.layer.borderWidth = 1
        weightTextView.layer.borderWidth = 1
        stepsTextView.layer.borderWidth = 1
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

