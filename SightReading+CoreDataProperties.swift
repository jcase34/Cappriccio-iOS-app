//
//  SightReading+CoreDataProperties.swift
//  Lento
//
//  Created by Jacob Case on 1/12/23.
//
//

import Foundation
import CoreData


extension SightReading {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SightReading> {
        return NSFetchRequest<SightReading>(entityName: "SightReading")
    }

    @NSManaged public var sightReading: String?

}

extension SightReading : Identifiable {

}
