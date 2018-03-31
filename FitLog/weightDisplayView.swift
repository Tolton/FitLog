//
//  weightDisplayView.swift
//  FitLog
//
//  Created by Jack on 2018-03-28.
//  Copyright © 2018 Jack. All rights reserved.
// Some Charts code structure used from https://medium.com/@OsianSmith/creating-a-line-chart-in-swift-3-and-ios-10-2f647c95392e

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Charts


class weightDisplayView: UIViewController, UITextFieldDelegate {

    var chartData = [ChartDataEntry]()
    var weightList = [Double]()
    var dateList = [String]()
    var ref: DatabaseReference!
    
    @IBOutlet weak var weightChartView: LineChartView!
    @IBOutlet weak var weightTextField: UITextField!
    
    @IBAction func weightLogButton(_ sender: UIButton) {
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        
        let currWeight = Double(weightTextField.text!)
        
        //get the current date
        let date = Date()
        let formatDate = DateFormatter()
        formatDate.dateFormat = "dd-MM-yyyy"
        let thisDate = formatDate.string(from: date)
       
        //Update the current weight
        self.ref.updateChildValues(["\(userID!)/\(thisDate)/Weight/": "\(currWeight!)"])
        
        //Update the chart
        weightList.remove(at: 0)
        weightList.insert(currWeight!, at: 0)
        updateGraph()

    }
    
    
    func createGraph() {
        let userID = Auth.auth().currentUser?.uid
        ref = Database.database().reference()
        
        let calendar = Calendar.current
        let formatDate = DateFormatter()
        formatDate.dateFormat = "dd-MM-yyyy"
        
        for i in 0...30 {
            //iterate through the last 30 days to get the weights
            let prevDate = calendar.date(byAdding: .day, value: -i, to: Date())
            let thisDate = formatDate.string(from: prevDate!)
            
            ref.child(userID!).child(thisDate).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get food/steps/weight children
                let value = snapshot.value as? NSDictionary
                
                
                if value != nil {
                    //if there is a weight for that day, add it to the list
                    let currWeight = value?["Weight"] as? String ?? ""
                    self.weightList.append(Double(currWeight)!)
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
        self.weightList = self.weightList.reversed()
        self.dateList = self.dateList.reversed()
        for h in 0..<self.weightList.count {
            let newData = ChartDataEntry(x: Double(h), y: self.weightList[h])
            self.chartData.append(newData)
        }
        
        //add the lines and update the graph
        let line = LineChartDataSet(values: self.chartData, label: "Weight")
        let data = LineChartData()
        data.addDataSet(line)
        
        //Put the dates as the x axis values
        self.weightChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dateList)
        self.weightChartView.xAxis.granularity = 1
        
        //Add the graph to the View
        self.weightChartView.data = data
        
        //Put the lists back in the correct order
        self.weightList = self.weightList.reversed()
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
        weightTextField.delegate = self
        createGraph()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
