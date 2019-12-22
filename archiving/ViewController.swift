//
//  ViewController.swift
//  archiving
//
//  Created by kjkl on 12/20/19.
//  Copyright © 2019 kjkl. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var resultsLbl: UILabel!
    
    var sensors: [Sensor]?
    var readings: [Reading]?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func printLog(message: String, startTime: NSDate) {
        let measuredTime = abs(startTime.timeIntervalSinceNow)
        let formattedTime = String(format: "%.4f", measuredTime)
        let text = resultsLbl.text ?? ""
       resultsLbl.text = text + "[\(formattedTime)s] \(message)\n"
    }
    
    @IBAction func generateData(_ sender: UIButton) {
        let startTime = NSDate();
        
        let readingsCount = 20
        let (sensors, readings) = DataManager.generateData(readingsCount: readingsCount)
        self.sensors = sensors
        self.readings = readings
        
        sensors.prefix(5).forEach { $0.toString() }
        print("...")
        readings.prefix(5).forEach { $0.toString() }
        print("...")
        
        printLog(message: "Data generated with \(readings.count) readings", startTime: startTime)
    }
    
    @IBAction func queryMinMaxTime(_ sender: UIButton) {
        let startTime = NSDate();

        if readings != nil {
            let timestamps: [Int] = readings!.map { $0.timestamp }
            let formattedMin = Utils.formatTimestamp(timestamp: timestamps.min()!)
            let formattedMax = Utils.formatTimestamp(timestamp: timestamps.max()!)
            
            print("Min timestamp='formattedMin', Max timestamp='\(formattedMax)'")
            printLog(message: "Min='\(formattedMin)', Max='\(formattedMax)'", startTime: startTime)
        } else {
            printLog(message: "No reading data available", startTime: startTime)
        }
    }
    
    @IBAction func queryAverageValue(_ sender: UIButton) {
        let startTime = NSDate();
        
        if let readings = self.readings {
            let valuesSum: Double = readings.map({ $0.value }).reduce(0, +)
            let valuesAvg: Double = valuesSum / Double(readings.count)
            let formattedAvg = String(format: "%.2f", valuesAvg)
            
            print("Average reading value='\(formattedAvg)'")
            printLog(message: "Average value='\(formattedAvg)'", startTime: startTime)
        } else {
            printLog(message: "No reading data available", startTime: startTime)
        }
    }
    
    @IBAction func querySensorAverageValue(_ sender: UIButton) {
        let startTime = NSDate();
        
        if let readings = self.readings, let sensors = self.sensors {
            var sensorValues = [String: [Double]]()
            sensors.forEach { sensorValues[$0.name] = [] }
            readings.forEach { sensorValues[$0.sensorName]?.append($0.value) }
            
//            dump(sensorValues)
            
            for (sensorName, readingValues) in sensorValues {
                let formattedCount = String(format: "%3d", readingValues.count)

                if (readingValues.isEmpty) {
                    print("Sensor='\(sensorName)', readingCount=\(formattedCount), avg=n/a")
                } else {
                    let valuesSum: Double = readingValues.reduce(0, +)
                    let valuesAvg: Double = valuesSum / Double(readingValues.count)
                    let formattedAvg = String(format: "%.2f", valuesAvg)
                    
                    print("Sensor='\(sensorName)', readingCount=\(formattedCount), avg=\(formattedAvg)")
                }
            }
            
            printLog(message: "Average value for each sensor calculated", startTime: startTime)
        } else {
            printLog(message: "No sensor or reading data available", startTime: startTime)
        }
    }
    
    
}

