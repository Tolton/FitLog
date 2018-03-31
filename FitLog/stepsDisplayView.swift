//
//  stepsDisplayView.swift
//  FitLog
//
//  Created by Jack on 2018-03-28.
//  Copyright © 2018 Jack. All rights reserved.
//// Some Charts code structure used from https://medium.com/@OsianSmith/creating-a-line-chart-in-swift-3-and-ios-10-2f647c95392e

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Charts

class stepsDisplayView: UIViewController, UITextFieldDelegate {
    
    var chartData = [ChartDataEntry]()
    var stepsList = [Double]()
    var dateList = [String]()
    var ref: DatabaseReference!
    
    @IBOutlet weak var stepsChartView: LineChartView!
    @IBOutlet weak var stepsTextField: UITextField!
    
    @IBAction func stepsAddButton(_ sender: UIButton) {
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        
        let currSteps = Double(stepsTextField.text!)
        
        //get the current date
        let date = Date()
        let formatDate = DateFormatter()
        formatDate.dateFormat = "dd-MM-yyyy"
        let thisDate = formatDate.string(from: date)
        
        var newSteps = stepsList.first
        newSteps = newSteps! + currSteps!
        //Update the current steps
        self.ref.updateChildValues(["\(userID!)/\(thisDate)/Steps/": "\(newSteps!)"])
        
        //Update the chart
        stepsList.remove(at: 0)
        stepsList.insert(newSteps!, at: 0)
        updateGraph()
        
    }
    
    
    func createGraph() {
        let userID = Auth.auth().currentUser?.uid
        ref = Database.database().reference()
        
        let calendar = Calendar.current
        let formatDate = DateFormatter()
        formatDate.dateFormat = "dd-MM-yyyy"
        
        for i in 0...30 {
            //iterate through the last 30 days to get the steps
            let prevDate = calendar.date(byAdding: .day, value: -i, to: Date())
            let thisDate = formatDate.string(from: prevDate!)
            
            ref.child(userID!).child(thisDate).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get food/steps/weight children
                let value = snapshot.value as? NSDictionary
                
                
                if value != nil {
                    //if there is steps for that day, add it to the list
                    let currSteps = value?["Steps"] as? String ?? ""
                    self.stepsList.append(Double(currSteps)!)
                    self.dateList.append(thisDate)
                    
                }
                if i == 30 {
                    self.updateGraph()
                }
            })
            
        }
        
        
        
    }
    
    //create the graph
    func updateGraph() {
        
        self.chartData.removeAll()
        //reverse the array and create the data points
        self.stepsList = self.stepsList.reversed()
        self.dateList = self.dateList.reversed()
        for h in 0..<self.stepsList.count {
            let newData = ChartDataEntry(x: Double(h), y: self.stepsList[h])
            self.chartData.append(newData)
        }
        
        //add the lines and update the graph
        let line = LineChartDataSet(values: self.chartData, label: "Steps")
        let data = LineChartData()
        data.addDataSet(line)
        
        //Put the dates as the x axis values
        self.stepsChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dateList)
        self.stepsChartView.xAxis.granularity = 1
        
        //Add the graph to the View
        self.stepsChartView.data = data
        
        //Put the lists back in the correct order
        self.stepsList = self.stepsList.reversed()
        self.dateList = self.dateList.reversed()
    }
    
    //Code snippet used from https://stackoverflow.com/questions/30973044/how-to-restrict-uitextfield-to-take-only-numbers-in-swift?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stepsTextField.delegate = self
        createGraph()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
