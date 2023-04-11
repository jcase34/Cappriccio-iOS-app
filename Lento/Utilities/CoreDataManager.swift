//
//  CoreDataManager.swift
//  Lento
//
//  Created by Jacob Case on 4/10/23.
//

import Foundation
import CoreData

class CoreDataManager {
    
    private let modelName: String
    
    private init(modelName: String) {
        self.modelName = modelName
    }
    
    static let shared = CoreDataManager(modelName: "Practice Session")
    
    lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores {
            (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
            
        }
        return container
    }()
    
    
    func saveContext() {
        guard managedContext.hasChanges else {return}
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    
    func insertMainPiece(mainPiece: String) {
        
    }
    
    func insertSightReading(sightReading: String) {
        
    }
    
    func insertImprovsation(improvsation: String) {
        
    }
    
    func insertRepertoire(repertoire: String) {
        
    }
    
    func updatePracticeSession() {
        
    }
    
    func insertPracticeSession(sectionDate: Date, sessionDate: Date, minutes: Int16, majorScale: String, minorScale: String, mainPiece: String, sightReading: String, improvisation: String, repertoire: String) {
        
        let newSession = PracticeSession(context: self.managedContext)
        
        newSession.sectionDate = sectionDate
        newSession.sessionDate = sessionDate
        newSession.minutes = minutes
        newSession.majorScale = majorScale
        newSession.minorScale = minorScale
        newSession.mainPiece = mainPiece
        newSession.sightReading = sightReading
        newSession.improvisation = improvisation
        newSession.reportoire = repertoire
        
        self.saveContext()
            
    }
    
    func fetchSessionItems() {
        
    }
    
    func deleteSessionItem() {
        
    }
    
    func deletePracticeSession(practiceSession: PracticeSession) {
        
    }
    
//    func fetchSortedPracticeSessionsByDate() -> [PracticeSession] {
//        
//        //return
//    }
    
    func fetchTotalPracticeSessiondMinutes() -> Int16{
        var totalMinutes: Int16 = 0
        
        var pSessions: [PracticeSession] = []
        
        let fetchRequest = NSFetchRequest<PracticeSession>(entityName: K.practiceSession)
        
        do {
            pSessions = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch sessions. \(error), \(error.userInfo) ")
        }
    
        for pSession in pSessions {
            totalMinutes += pSession.minutes
        }
        
        
        return totalMinutes
    }
    
    func fetchTotalPracticeSessionCount() -> Int {
        
        var pSessions: [PracticeSession] = []
        
        let fetchRequest = NSFetchRequest<PracticeSession>(entityName: K.practiceSession)
        
        do {
            pSessions = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch sessions. \(error), \(error.userInfo) ")
        }
        
        return pSessions.count
    }
    
}
