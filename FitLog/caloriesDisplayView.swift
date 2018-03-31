//
//  caloriesDisplayView.swift
//  FitLog
//
//  Created by Jack on 2018-03-28.
//  Copyright © 2018 Jack. All rights reserved.
//// Some Charts code structure used from https://medium.com/@OsianSmith/creating-a-line-chart-in-swift-3-and-ios-10-2f647c95392e

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Charts

class caloriesDisplayView: UIViewController {
    
    var chartData = [ChartDataEntry]()
    var caloriesList = [Double]()
    var dateList = [String]()
    var ref: DatabaseReference!
    
    @IBOutlet weak var caloriesChartView: LineChartView!
    
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
                    let currCalories = value?["Food"] as? String ?? ""
                    self.caloriesList.append(Double(currCalories)!)
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
        self.caloriesList = self.caloriesList.reversed()
        self.dateList = self.dateList.reversed()
        for h in 0..<self.caloriesList.count {
            let newData = ChartDataEntry(x: Double(h), y: self.caloriesList[h])
            self.chartData.append(newData)
        }
        
        //add the lines and update the graph
        let line = LineChartDataSet(values: self.chartData, label: "Calories")
        let data = LineChartData()
        data.addDataSet(line)
        
        //Put the dates as the x axis values
        self.caloriesChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dateList)
        self.caloriesChartView.xAxis.granularity = 1
        
        //Add the graph to the View
        self.caloriesChartView.data = data
        
        //Put the lists back in the correct order
        self.caloriesList = self.caloriesList.reversed()
        self.dateList = self.dateList.reversed()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createGraph()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
