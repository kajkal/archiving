//
//  DataService.swift
//  archiving
//
//  Created by kjkl on 12/20/19.
//  Copyright © 2019 kjkl. All rights reserved.
//

import Foundation

class DataManager {
    
    func saveData(data: (sensors: [Sensor], readings: [Reading])) {
        saveSensorsData(sensors: data.sensors)
        saveReadingsData(readings: data.readings)
    }
    
    func loadData() -> (sensors: [Sensor], readings: [Reading]) {
        return (
            sensors: readAllSensorsRows(),
            readings: readAllReadingRows()
        )
    }
    
    func getMinAndMaxTimestamps() -> (min: Int, max: Int) {
        let data = loadData()

        let timestamps: [Int] = data.readings.map { $0.timestamp }
        return (min: timestamps.min() ?? -1, max: timestamps.max() ?? -1)
    }
    
    func getAverageReadingValue() -> Double {
        let data = loadData()
        
        let valuesSum: Double = data.readings.map({ $0.value }).reduce(0, +)
        return valuesSum / Double(data.readings.count)
    }
    
    func getAverageReadingValueGroupedBySensor() -> [String: (avg: Double, count: Int)] {
        let data = loadData()

        var tmpSensorValues = [String: [Double]]()
        data.sensors.forEach { tmpSensorValues[$0.name] = [] }
        data.readings.forEach { tmpSensorValues[$0.sensorName]?.append($0.value) }
        
        var sensorValues = [String: (avg: Double, count: Int)]()
        for (sensorName, readingValues) in tmpSensorValues {
            if (!readingValues.isEmpty) {
                let valuesSum: Double = readingValues.reduce(0, +)
                let valuesAvg: Double = valuesSum / Double(readingValues.count)
                sensorValues[sensorName] = (avg: valuesAvg, count: readingValues.count)
            }
        }
        
//        dump(sensorValues)
        return sensorValues
    }
        
    private func saveSensorsData(sensors: [Sensor]) {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: sensors, requiringSecureCoding: false)
            try data.write(to: Sensor.ArchiveURL)
            print("Sensors data successfully saved")
        } catch {
            print("Failed to saved sensors data")
        }
    }
    
    private func saveReadingsData(readings: [Reading]) {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: readings, requiringSecureCoding: false)
            try data.write(to: Reading.ArchiveURL)
            print("Readings data successfully saved")
        } catch {
            print("Failed to saved reading data")
        }
    }
    
    private func readAllSensorsRows() -> [Sensor] {
        if let nsData = NSData(contentsOf: Sensor.ArchiveURL) {
            do {
                let data = Data(referencing:nsData)

                if let loadedSensors = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Sensor] {
                    return loadedSensors
                }
            } catch {
                print("Couldn't read file")
                return []
            }
        }
        return []
    }
    
    private func readAllReadingRows() -> [Reading] {
        if let nsData = NSData(contentsOf: Reading.ArchiveURL) {
            do {
                let data = Data(referencing:nsData)

                if let loadedReading = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Reading] {
                    return loadedReading
                }
            } catch {
                print("Couldn't read file")
                return []
            }
        }
        return []
    }
    
}
