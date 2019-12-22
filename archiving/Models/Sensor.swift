//
//  Sensor.swift
//  archiving
//
//  Created by kjkl on 12/20/19.
//  Copyright © 2019 kjkl. All rights reserved.
//

import Foundation

class Sensor: NSObject, NSCoding {

    //MARK: Properties
    var name: String
    var desc: String

    //MARK: Types
    struct PropertyKey {
        static let name = "name"
        static let desc = "desc"
    }

    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("sensors")

    //MARK: Initialization
    init?(name: String, desc: String) {
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }

        // The description must not be empty
        guard !desc.isEmpty else {
            return nil
        }

        self.name = name;
        self.desc = desc;
    }

    //MARK: NSCoding
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: PropertyKey.name)
        coder.encode(desc, forKey: PropertyKey.desc)
    }
    
    required convenience init?(coder decoder: NSCoder) {
        // The name is required
        guard let name = decoder.decodeObject(forKey: PropertyKey.name) as? String else {
            print("Unable to decode the name for a Sensor object.")
            return nil
        }

        // The description is required
        guard let desc = decoder.decodeObject(forKey: PropertyKey.desc) as? String else {
            print("Unable to decode the desc for a Sensor object.")
            return nil
        }

        // Must call designated initializer.
        self.init(name: name, desc: desc)
    }
    
    // just for develop
    func toString() {
        print("Sensor (name='\(name)', desc='\(desc)')")
    }

}
