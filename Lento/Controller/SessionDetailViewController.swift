//
//  ScalesTableViewController.swift
//  Lento
//
//  Created by Jacob Case on 1/11/23.
//

import Foundation
import UIKit
import CoreData

protocol SessionDetailViewControllerDelegate: AnyObject {
    func SessionDetailViewController(_ controller: SessionDetailViewController, didFinishAddingMajorScale scale: String)
    func SessionDetailViewController(_ controller: SessionDetailViewController, didFinishAddingMinorScale scale: String)
    func SessionDetailViewController(_ controller: SessionDetailViewController, didFinishAddingMainPiece content: String)
    func SessionDetailViewController(_ controller: SessionDetailViewController, didFinishAddingSightReading content: String)
    func SessionDetailViewController(_ controller: SessionDetailViewController, didFinishAddingImprovisation content: String)
    func SessionDetailViewController(_ controller: SessionDetailViewController, didFinishAddingRepertoire content: String)

}

class SessionDetailViewController: UITableViewController {
    
    //Propogated properties
    var tagNumber: Int!
    var selectedScale: String!
    var selectedContent: String!
    
    //placeholders for all session items
    var sessionItems: [NSManagedObject]!
    
    //Delegate for passback
    weak var delegate: SessionDetailViewControllerDelegate?
    
    var sItem: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        print("tag Number \(tagNumber)")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        
        //CoreDataCalls
        print("getting items")
        if (tagNumber > 11) {
            getSessionItems()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavBarFromTagNumber(tagNumber)
    }
    
    func configureNavBarFromTagNumber(_ tag: Int) {
        switch tag {
        case SessionItem.majorScale.rawValue:
            self.navigationItem.title = "Select a Major Scale"
        case SessionItem.minorScale.rawValue:
            self.navigationItem.title = "Select a Minor Scale"
        default:
            self.navigationItem.title = "Select "
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        }
    }
}

//MARK: - Actions
extension SessionDetailViewController {
    
     @objc func addButtonTapped() {
        let alert = UIAlertController(title: "New Content", message: nil, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let textField = alert.textFields?.first,
                  let itemToSave = textField.text else {return}
            
            self.sItem = itemToSave
            self.saveSessionItems()
            self.tableView.reloadData()
          }
          let cancelAction = UIAlertAction(title: "Cancel",
                                           style: .cancel)
          alert.addTextField()
          alert.addAction(saveAction)
          alert.addAction(cancelAction)
          present(alert, animated: true)
    }
}

//MARK: - Table View Methods
extension SessionDetailViewController {
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tagNumber {
        case SessionItem.majorScale.rawValue:
            return getScaleCount()
        case SessionItem.minorScale.rawValue:
            return getScaleCount()
        case SessionItem.mainPiece.rawValue:
            return sessionItems.count
        case SessionItem.sightReading.rawValue:
            return sessionItems.count
        case SessionItem.improvisation.rawValue:
            return sessionItems.count
        case SessionItem.reportoire.rawValue:
            return sessionItems.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        switch tagNumber {
        case SessionItem.majorScale.rawValue:
            let scales = getMajorScaleTitles()
            cell.textLabel?.text = scales[indexPath.row]
        case SessionItem.minorScale.rawValue:
            let scales = getMinorScaleTitles()
            cell.textLabel?.text = scales[indexPath.row]
        case SessionItem.mainPiece.rawValue:
            if let items = sessionItems as? [MainPiece] {
                cell.textLabel!.text = items[indexPath.row].mainPiece
            }
        case SessionItem.sightReading.rawValue:
            if let items = sessionItems as? [SightReading] {
                cell.textLabel!.text = items[indexPath.row].sightReading
            }
        case SessionItem.improvisation.rawValue:
            if let items = sessionItems as? [Improvisation] {
                cell.textLabel!.text = items[indexPath.row].improvisation
            }
        case SessionItem.reportoire.rawValue:
            if let items = sessionItems as? [Repertoire] {
                cell.textLabel!.text = items[indexPath.row].repertoire
            }
        default:
            break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tagNumber {
        case SessionItem.majorScale.rawValue:
            selectedScale = tableView.cellForRow(at: indexPath)?.textLabel?.text
            tableView.deselectRow(at: indexPath, animated: true)
            delegate?.SessionDetailViewController(self, didFinishAddingMajorScale: selectedScale)
            
        case SessionItem.minorScale.rawValue:
            selectedScale = tableView.cellForRow(at: indexPath)?.textLabel?.text
            tableView.deselectRow(at: indexPath, animated: true)
            delegate?.SessionDetailViewController(self, didFinishAddingMinorScale: selectedScale)
            
        case SessionItem.mainPiece.rawValue:
            selectedContent = tableView.cellForRow(at: indexPath)?.textLabel?.text
            tableView.deselectRow(at: indexPath, animated: true)
            delegate?.SessionDetailViewController(self, didFinishAddingMainPiece: selectedContent)
            
        case SessionItem.sightReading.rawValue:
            selectedContent = tableView.cellForRow(at: indexPath)?.textLabel?.text
            tableView.deselectRow(at: indexPath, animated: true)
            delegate?.SessionDetailViewController(self, didFinishAddingSightReading: selectedContent)
            
        case SessionItem.improvisation.rawValue:
            selectedContent = tableView.cellForRow(at: indexPath)?.textLabel?.text
            tableView.deselectRow(at: indexPath, animated: true)
            delegate?.SessionDetailViewController(self, didFinishAddingImprovisation: selectedContent)
            
        case SessionItem.reportoire.rawValue:
            selectedContent = tableView.cellForRow(at: indexPath)?.textLabel?.text
            tableView.deselectRow(at: indexPath, animated: true)
            delegate?.SessionDetailViewController(self, didFinishAddingRepertoire: selectedContent)
            
        default:
            break
            
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        let sessionItemToDelete = sessionItems[indexPath.row]
        //managedContext.delete(sessionItemToDelete)
        CoreDataManager.shared.deleteSessionItem(itemToDelete: sessionItemToDelete)
        sessionItems.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

//MARK: - Core Data Methods
extension SessionDetailViewController {

    func getSessionItems() {
        
        var entityName: String = ""
        
        switch tagNumber {
        case SessionItem.mainPiece.rawValue:
            entityName = Entities.mainPiece.rawValue
        case SessionItem.sightReading.rawValue:
            entityName = Entities.sightReading.rawValue
        case SessionItem.improvisation.rawValue:
            entityName = Entities.improvisation.rawValue
        case SessionItem.reportoire.rawValue:
            entityName = Entities.reportoire.rawValue
        default:
            break
        }

        sessionItems = CoreDataManager.shared.fetchSessionItems(entityName: entityName)
    }
    
    func saveSessionItems() {
        switch tagNumber {
        case SessionItem.mainPiece.rawValue:
            let mPiece = CoreDataManager.shared.insertMainPiece(mainPiece: sItem)!
            sessionItems.append(mPiece)
            
        case SessionItem.sightReading.rawValue:
            let sReading = CoreDataManager.shared.insertSightReading(sightReading: sItem)!
            sessionItems.append(sReading)
            
        case SessionItem.improvisation.rawValue:
            let improv = CoreDataManager.shared.insertImprovsation(improvsation: sItem)!
            sessionItems.append(improv)
            
        case SessionItem.reportoire.rawValue:
            let repert = CoreDataManager.shared.insertRepertoire(repertoire: sItem)!
            sessionItems.append(repert)
            
        default:
            break
        }
        
    }
}

