//
//  Constants.swift
//  Lento
//
//  Created by Jacob Case on 1/9/23.
//

import Foundation
import CoreData

struct K {
    

    static let practiceSession = "PracticeSession"
    static let date = "Date"
    static let minutes = "Minutes"
    static let majorScale = "MajorScale"
    static let minorScale = "MinorScale"
    static let mainPiece = "MainPiece"
    static let sightReading = "SightReading"
    static let improvisation = "Improvisation"
    static let reportoire = "Repertoire"
    
    static let applicationTitle = "Lento"
    
    static let sectionTitles = ["Session Details", "Scale", "Main Piece", "Sight Reading", "Improvisation", "Repertoire", "Recording"]
}


enum SessionIcons: String, CaseIterable {
    case majorScale = "♯"
    case minorScale = "♭"
    case mainPiece = "🎼"
    case sightReading = "📝"
    case improvisation = "🎶"
    case reportoire = "🗄️"
}



enum SessionItem: Int, CaseIterable {
    case majorScale = 10
    case minorScale = 11
    case mainPiece = 12
    case sightReading = 13
    case improvisation = 14
    case reportoire = 15
    
}

enum Entities: String, CaseIterable {
    case date = "Date"
    case minutes = "Minutes"
    case majorScale = "MajorScale"
    case minorScale = "MinorScale"
    case mainPiece = "MainPiece"
    case sightReading = "SightReading"
    case improvisation = "Improvisation"
    case reportoire = "Repertoire"
}

