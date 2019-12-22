//
//  DataService.swift
//  archiving
//
//  Created by kjkl on 12/20/19.
//  Copyright © 2019 kjkl. All rights reserved.
//

import Foundation

struct DataManager {
        
    // saves data in device memory
    static func saveData(data: (sensors: [Sensor], readings: [Reading])) {
        saveSensorsData(sensors: data.sensors)
        saveReadingsData(readings: data.readings)
    }
    
    // loads data from device memory
    static func loadData() -> (sensors: [Sensor]?, readings: [Reading]?) {
        return (
            sensors: readSensorsData(),
            readings: readReadingData()
        )
    }
    
    private static func saveSensorsData(sensors: [Sensor]) {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: sensors, requiringSecureCoding: false)
            try data.write(to: Sensor.ArchiveURL)
            print("Sensors data successfully saved.")
        } catch {
            print("Failed to saved sensors data")
        }
    }
    
    private static func saveReadingsData(readings: [Reading]) {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: readings, requiringSecureCoding: false)
            try data.write(to: Reading.ArchiveURL)
            print("Readings data successfully saved.")
        } catch {
            print("Failed to saved reading data")
        }
    }
    
    private static func readSensorsData() -> [Sensor]? {
        if let nsData = NSData(contentsOf: Sensor.ArchiveURL) {
            do {
                let data = Data(referencing:nsData)

                if let loadedSensors = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Sensor] {
                    return loadedSensors
                }
            } catch {
                print("Couldn't read file.")
                return nil
            }
        }
        return nil
    }
    
    private static func readReadingData() -> [Reading]? {
        if let nsData = NSData(contentsOf: Reading.ArchiveURL) {
            do {
                let data = Data(referencing:nsData)

                if let loadedReading = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Reading] {
                    return loadedReading
                }
            } catch {
                print("Couldn't read file.")
                return nil
            }
        }
        return nil
    }

    static func generateData(readingsCount: Int) -> (sensors: [Sensor], readings: [Reading]) {
        let sensorCount = 20
        
        let sensors: [Sensor] = Array(1...sensorCount).map {
            Sensor(
                name: "S\(String(format: "%02d", $0))",
                desc: "Sensor number \($0)"
            )!
        }
        let readings: [Reading] = Array(1...readingsCount).map {_ in
             Reading(
               timestamp: Utils.generateTimestamp(),
               sensorName: sensors[Int.random(in: 0 ..< sensorCount)].name,
               value: Utils.generateValue()
           )!
        }
        
        return (
            sensors: sensors,
            readings: readings
        )
    }
    
}
