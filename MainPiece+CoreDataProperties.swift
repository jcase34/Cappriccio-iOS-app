//
//  MainPiece+CoreDataProperties.swift
//  Lento
//
//  Created by Jacob Case on 1/12/23.
//
//

import Foundation
import CoreData


extension MainPiece {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MainPiece> {
        return NSFetchRequest<MainPiece>(entityName: "MainPiece")
    }

    @NSManaged public var mainPiece: String?

}

extension MainPiece : Identifiable {

}
