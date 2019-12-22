//
//  Reading.swift
//  archiving
//
//  Created by kjkl on 12/20/19.
//  Copyright © 2019 kjkl. All rights reserved.
//

import Foundation

class Reading: NSObject, NSCoding {

    //MARK: Properties
    var timestamp: Int
    var sensorName: String
    var value: Double

    //MARK: Types
    struct PropertyKey {
        static let timestamp = "timestamp"
        static let sensorName = "sensor_name"
        static let value = "value"
    }

    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("readings")

    //MARK: Initialization
    init?(timestamp: Int, sensorName: String, value: Double) {
        // The timestamp must be greater than 0
        guard timestamp > 0 else {
            return nil
        }

        // The sensor name must not be empty
        guard !sensorName.isEmpty else {
            return nil
        }

        // The value must be greater than 0
        guard value > 0 else {
            return nil
        }

        self.timestamp = timestamp;
        self.sensorName = sensorName;
        self.value = value;
    }

    //MARK: NSCoding
    func encode(with coder: NSCoder) {
        coder.encode(timestamp, forKey: PropertyKey.timestamp)
        coder.encode(sensorName, forKey: PropertyKey.sensorName)
        coder.encode(value, forKey: PropertyKey.value)
    }
    
    required convenience init?(coder decoder: NSCoder) {
        // The timestamp is required.
        let timestamp = decoder.decodeInteger(forKey: PropertyKey.timestamp)

        // The sensor name is required.
        guard let sensorName = decoder.decodeObject(forKey: PropertyKey.sensorName) as? String else {
            print("Unable to decode the sensorName for a Reading object.")
            return nil
        }

        // The value is required.
        let value = decoder.decodeDouble(forKey: PropertyKey.value)

        // Must call designated initializer.
        self.init(timestamp: timestamp, sensorName: sensorName, value: value)
    }
    
    // just for develop
    func toString() {
        print("Reading (timestamp=\(timestamp), sensorName='\(sensorName)', value=\(value))")
    }

}


