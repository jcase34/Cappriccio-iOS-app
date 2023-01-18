//
//  Improvisation+CoreDataProperties.swift
//  Lento
//
//  Created by Jacob Case on 1/12/23.
//
//

import Foundation
import CoreData


extension Improvisation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Improvisation> {
        return NSFetchRequest<Improvisation>(entityName: "Improvisation")
    }

    @NSManaged public var improvisation: String?

}

extension Improvisation : Identifiable {

}
