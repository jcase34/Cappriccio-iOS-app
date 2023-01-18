//
//  PracticeSession+CoreDataProperties.swift
//  Lento
//
//  Created by Jacob Case on 1/17/23.
//
//

import Foundation
import CoreData


extension PracticeSession {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PracticeSession> {
        return NSFetchRequest<PracticeSession>(entityName: "PracticeSession")
    }

    @NSManaged public var date: Date?
    @NSManaged public var improvisation: String?
    @NSManaged public var mainPiece: String?
    @NSManaged public var majorScale: String?
    @NSManaged public var minorScale: String?
    @NSManaged public var minutes: Int16
    @NSManaged public var reportoire: String?
    @NSManaged public var sightReading: String?

}

extension PracticeSession : Identifiable {

}
