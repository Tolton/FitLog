//
//  weightDisplayView.swift
//  FitLog
//
//  Created by Jack on 2018-03-28.
//  Copyright © 2018 Jack. All rights reserved.
// Some Charts code structure used from https://medium.com/@OsianSmith/creating-a-line-chart-in-swift-3-and-ios-10-2f647c95392e

import UIKit
import Charts


class weightDisplayView: UIViewController {

    var chartData = [ChartDataEntry]()
    
    
    @IBOutlet weak var weightChartView: LineChartView!
    @IBOutlet weak var weightTextField: UITextField!
    
    @IBAction func weightLogButton(_ sender: UIButton) {
        let num = Double(weightTextField.text!)
        //send weightTextField.text to backend and refresh the graph
        
        let value = ChartDataEntry(x: Double(chartData.count), y: num!)
        chartData.append(value)
        updateGraph()

    }
    
    func updateGraph() {
        let line = LineChartDataSet(values: chartData, label: "Weight")
        let data = LineChartData()
        data.addDataSet(line)
        weightChartView.data = data
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
        for i in 0...10 {
            let value = ChartDataEntry(x: Double(i), y: unitsSold[i])
            chartData.append(value)
        }
        updateGraph()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
