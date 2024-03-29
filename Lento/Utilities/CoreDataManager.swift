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
    
    
    func insertMainPiece(mainPiece: String) -> NSManagedObject? {
        let newPiece = NSEntityDescription.insertNewObject(forEntityName: Entities.mainPiece.rawValue, into: managedContext) as! MainPiece
        newPiece.mainPiece = mainPiece
        saveContext()
        
        return newPiece
    }
    
    func insertSightReading(sightReading: String) -> NSManagedObject? {
        let sReading = NSEntityDescription.insertNewObject(forEntityName: Entities.sightReading.rawValue, into: managedContext) as! SightReading
        sReading.sightReading = sightReading
        saveContext()
        
        return sReading
    }
    
    func insertImprovsation(improvsation: String) -> NSManagedObject? {
        let improv = NSEntityDescription.insertNewObject(forEntityName: Entities.improvisation.rawValue, into: managedContext) as! Improvisation
        improv.improvisation = improvsation
        saveContext()
        
        return improv
    }
    
    func insertRepertoire(repertoire: String) -> NSManagedObject? {
        let repert = NSEntityDescription.insertNewObject(forEntityName: Entities.reportoire.rawValue, into: managedContext) as! Repertoire
        repert.repertoire = repertoire
        saveContext()
        
        return repert
    }
    
    func updatePracticeSession(sectionDate: Date, sessionDate: Date, minutes: Int16, majorScale: String, minorScale: String, mainPiece: String, sightReading: String, improvisation: String, repertoire: String, practiceSession: PracticeSession) {
        
        let thisSession = practiceSession
        thisSession.sectionDate = sectionDate
        thisSession.sessionDate = sessionDate
        thisSession.minutes = minutes
        thisSession.majorScale = majorScale
        thisSession.minorScale = minorScale
        thisSession.mainPiece = mainPiece
        thisSession.sightReading = sightReading
        thisSession.improvisation = improvisation
        thisSession.reportoire = repertoire
        
        self.saveContext()
        
    }
    
    func insertPracticeSession(sectionDate: Date, sessionDate: Date, minutes: Int16, majorScale: String, minorScale: String, mainPiece: String, sightReading: String, improvisation: String, repertoire: String) -> PracticeSession? {
        
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
        
        return newSession
            
    }
    
    
    func deleteSessionItem(itemToDelete: NSManagedObject) {
        managedContext.delete(itemToDelete)
        saveContext()
    }
    
    func deletePracticeSession(practiceSession: PracticeSession) {
        managedContext.delete(practiceSession)
        saveContext()
    }
    
    func fetchSessionItems(entityName: String) -> [NSManagedObject] {
        var items = [NSManagedObject]()
        let request = NSFetchRequest<NSManagedObject>()
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)
        request.entity = entity
        
        do {
            items = try managedContext.fetch(request)
        } catch let error as NSError {
            print("error fetching session items \(error)")
        }
        
        return items
    }


    func fetchSortedPracticeSessionsByDate() -> [PracticeSession]? {
        var pSessions = [PracticeSession]()
        
        let fetchRequest = NSFetchRequest<PracticeSession>()
        let entity = NSEntityDescription.entity(forEntityName: K.practiceSession, in: managedContext)
        let dateSort = NSSortDescriptor(key: #keyPath(PracticeSession.sessionDate), ascending: true)
        fetchRequest.entity = entity
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            pSessions = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("error fetching sorted sessions \(error)")
        }
        
        return pSessions
    }
    
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
        var sessionCount: Int = 0
        
        let fetchRequest = NSFetchRequest<NSNumber>(entityName: K.practiceSession)
        fetchRequest.resultType = .countResultType
        
        do {
            let countResult = try managedContext.fetch(fetchRequest)
            sessionCount = countResult.first!.intValue
        } catch let error as NSError {
            print("Could not fetch sessions. \(error), \(error.userInfo) ")
        }
        
        return sessionCount
    }
    
}
