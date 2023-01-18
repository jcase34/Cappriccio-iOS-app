//
//  Repertoire+CoreDataProperties.swift
//  Lento
//
//  Created by Jacob Case on 1/13/23.
//
//

import Foundation
import CoreData


extension Repertoire {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Repertoire> {
        return NSFetchRequest<Repertoire>(entityName: "Repertoire")
    }

    @NSManaged public var repertoire: String?

}

extension Repertoire : Identifiable {

}
