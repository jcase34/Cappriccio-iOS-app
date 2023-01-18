//
//  ViewController.swift
//  Lento
//
//  Created by Jacob Case on 1/8/23.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    //Properties
    var practiceSessions = [PracticeSession]()
    
    var totalPracticeMinutes: Int16 = 0 {
        didSet {
            updateTableHeaderView()
        }
    }
    
    var totalSessionCount: Int = 0  {
        didSet {
            updateTableHeaderView()
        }
    }
    
    var mainHeaderView: MainHeaderView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //fetch all sessions upon loading
        practiceSessions = (CoreDataManager.shared.fetchPracticeSessions())!
        
        //Stylize
        self.navigationController!.navigationBar.prefersLargeTitles = true
        tableView.rowHeight = UITableView.automaticDimension    

        tableView.tableFooterView = copyrightFooterView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        
        //cell registration
        tableView.delegate = self
        tableView.dataSource = self

        
        mainHeaderView = MainHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 150))
        updateTableHeaderView()
        tableView.tableHeaderView = mainHeaderView
        
        tableView.register(PracticeSessionTableViewCell.self, forCellReuseIdentifier: PracticeSessionTableViewCell.identifier)
        
        totalPracticeMinutes = CoreDataManager.shared.fetchTotalPracticeSessiondMinutes()
        totalSessionCount = CoreDataManager.shared.fetchTotalPracticeSessionCount()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            //print(segue.identifier)
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
            //controller.managedContext = managedContext
        } else if segue.identifier == "EditItem" {
            //print(segue.identifier)
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
            //controller.managedContext = managedContext
            if let indexPath = sender as? IndexPath {
                print(indexPath)
                controller.sessionToBeEdited = practiceSessions[indexPath.row]
            }
        }
    }
    
    func updateTableHeaderView() {
        mainHeaderView.totalMinutesLabel.text = "\(totalPracticeMinutes)"
        mainHeaderView.sessionCountLabel.text = "\(totalSessionCount)"
    }
}

//MARK: - Self Table View Methods
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return practiceSessions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: PracticeSessionTableViewCell.identifier , for: indexPath) as! PracticeSessionTableViewCell
        let pSession = practiceSessions[indexPath.row]
        cell.dateLabel.text = formatDate(date: pSession.date!)
        cell.MinutesLabel.text = "\(pSession.minutes):00"
        cell.majorScaleLabel.text = pSession.majorScale ?? "None"
        cell.minorScaleLabel.text = pSession.minorScale ?? "None"
        cell.mainPieceLabel.text = pSession.mainPiece ?? "None"
        cell.sightReadingLabel.text = pSession.sightReading
        cell.improvLabel.text = pSession.improvisation
        cell.repertoireLabel.text = pSession.reportoire
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "EditItem", sender: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        let sessionToDelete = practiceSessions[indexPath.row]
        CoreDataManager.shared.deletePracticeSession(practiceSession: sessionToDelete)
        practiceSessions.remove(at: indexPath.row)
        

        tableView.deleteRows(at: [indexPath], with: .automatic)
        totalPracticeMinutes = CoreDataManager.shared.fetchTotalPracticeSessiondMinutes()
        totalSessionCount = CoreDataManager.shared.fetchTotalPracticeSessionCount()
    }
}

//MARK: - ItemDetailViewControllerDelegate Methods
extension HomeViewController: ItemDetailViewControllerDelegate {
    func ItemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        print("cancel tapped")
        navigationController?.popViewController(animated: true)
    }
    
    func ItemDetailViewController(_ controller: ItemDetailViewController, didFinishAddingSession practiceSession: PracticeSession) {
        navigationController?.popViewController(animated: true)
        
        let newRowIndex = practiceSessions.count
        practiceSessions.append(practiceSession)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .fade)
        totalPracticeMinutes = CoreDataManager.shared.fetchTotalPracticeSessiondMinutes()
        totalSessionCount = CoreDataManager.shared.fetchTotalPracticeSessionCount()
    }
    
    func ItemDetailViewController(_ controller: ItemDetailViewController, didFinishEditingSession practiceSession: PracticeSession) {

        if let index = practiceSessions.firstIndex(of: practiceSession) {
            let indexPath = IndexPath(row: index, section: 0)
                practiceSessions[indexPath.row] = practiceSession
        }
        totalPracticeMinutes = CoreDataManager.shared.fetchTotalPracticeSessiondMinutes()
        totalSessionCount = CoreDataManager.shared.fetchTotalPracticeSessionCount()
        navigationController?.popViewController(animated: true)
        tableView.reloadData()
    }
        
}



