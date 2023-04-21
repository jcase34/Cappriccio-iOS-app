//
//  ItemDetailViewController.swift
//  Lento
//
//  Created by Jacob Case on 1/8/23.
//

import UIKit
import CoreData
import DropDown

protocol ItemDetailViewControllerDelegate: AnyObject {
    func ItemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    
    //session dict to include date, minutes, and text from all text outlets
    func ItemDetailViewController(_ controller: ItemDetailViewController, didFinishAddingSession practiceSession: PracticeSession)
    
    func ItemDetailViewController(_ controller: ItemDetailViewController, didFinishEditingSession practiceSession: PracticeSession)
    
}

class ItemDetailViewController: UITableViewController   {
    
    //outlets
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var minutePicker: UIPickerView!
    @IBOutlet weak var majorScaleTextField: UITextField!
    @IBOutlet weak var minorScaleTextField: UITextField!
    @IBOutlet weak var mainPieceTextField: UITextField!
    @IBOutlet weak var sightReadingTextField: UITextField!
    @IBOutlet weak var improvisationTextField: UITextField!
    @IBOutlet weak var repertoireTextField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    //Delegate Property
    weak var delegate: ItemDetailViewControllerDelegate?
    
    //propogated properties
    var sessionToBeEdited: PracticeSession!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegate Assignments
        tableView.delegate = self
        minutePicker.delegate = self
        

        if let session = sessionToBeEdited {
            title = "Edit Session"
            datePicker.date = session.sessionDate!
            minutePicker.selectRow(Int(session.minutes), inComponent: 0, animated: true)
            majorScaleTextField.text = session.majorScale
            minorScaleTextField.text = session.minorScale
            mainPieceTextField.text = session.mainPiece
            sightReadingTextField.text = session.sightReading
            improvisationTextField.text = session.improvisation
            repertoireTextField.text = session.reportoire
            
        }
        
        // Styling Setup
        styleTableView()
        
        // Additional Setup
        //print(formatDate(picker: datePicker))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSessionInformation" {
            let controller = segue.destination as! SessionDetailViewController
            let indexPath = sender as! IndexPath
            let tag = tableView.cellForRow(at: indexPath)?.tag
            
            switch tag {
            case SessionItem.majorScale.rawValue:
                //major scale
                controller.tagNumber = tag
            case SessionItem.minorScale.rawValue:
                //minor scale
                controller.tagNumber = tag
            case SessionItem.mainPiece.rawValue:
                //main piece
                controller.tagNumber = tag
            case SessionItem.sightReading.rawValue:
                //sight reading
                controller.tagNumber = tag
            case SessionItem.improvisation.rawValue:
                //imporovisation
                controller.tagNumber = tag
            case SessionItem.reportoire.rawValue:
                //reportoire
                controller.tagNumber = tag
            default:
                break
            }
            controller.delegate = self
            //controller.managedContext = managedContext
        }
    }

}
//MARK: - Actions
extension ItemDetailViewController {
    @IBAction func cancel() {
        delegate?.ItemDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        
        if let pSession = sessionToBeEdited {
            
            guard let sectionDate = formatSectionDate(oldDate: datePicker.date) else {return}
            guard let sessionDate = formatSessionDate(oldDate: datePicker.date) else {return}
            
            CoreDataManager.shared.updatePracticeSession(
                sectionDate: sectionDate,
                sessionDate: sessionDate,
                minutes: Int16(minutePicker.selectedRow(inComponent: 0)),
                majorScale: majorScaleTextField.text!,
                minorScale: minorScaleTextField.text!,
                mainPiece: mainPieceTextField.text!,
                sightReading: sightReadingTextField.text!,
                improvisation: improvisationTextField.text!,
                repertoire: repertoireTextField.text!,
                practiceSession: pSession)
            
            delegate?.ItemDetailViewController(self, didFinishEditingSession: pSession)
        } else {
        //https://stackoverflow.com/questions/30543064/sectionname-in-tableview-with-date
            
            guard let sectionDate = formatSectionDate(oldDate: datePicker.date) else {return}
            guard let sessionDate = formatSessionDate(oldDate: datePicker.date) else {return}
            
            let pSession = CoreDataManager.shared.insertPracticeSession(
                sectionDate: sectionDate,
                sessionDate: sessionDate,
                minutes: Int16(minutePicker.selectedRow(inComponent: 0)),
                majorScale: majorScaleTextField.text?.isEmpty == true ? "None" : majorScaleTextField.text!,
                minorScale: minorScaleTextField.text?.isEmpty == true ? "None" : minorScaleTextField.text!,
                mainPiece: mainPieceTextField.text?.isEmpty == true ? "None" : mainPieceTextField.text!,
                sightReading: sightReadingTextField.text?.isEmpty == true ? "None" : sightReadingTextField.text!,
                improvisation: improvisationTextField.text?.isEmpty == true ? "None" : improvisationTextField.text!,
                repertoire: repertoireTextField.text?.isEmpty == true ? "None" : repertoireTextField.text!)!
            delegate?.ItemDetailViewController(self, didFinishAddingSession: pSession)
        }
    }
}

//MARK: - Table View Methods
extension ItemDetailViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let tag = tableView.cellForRow(at: indexPath)?.tag
        
        if (tag! > 1) {
            performSegue(withIdentifier: "toSessionInformation", sender: indexPath)
        }
        else {
            return
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = K.sectionTitles[section]
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .natural
        label.textColor = .black
        return label
    }
}


//MARK: - Minute Picker View Methods
extension ItemDetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 121
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let minutes = Array(0...121)
        var label = UILabel()
        if let view = view as? UILabel { label = view }
        label.font = UIFont(name: "Helvetica Neue", size: 14)
        label.text = "\(minutes[row])"
        label.textAlignment = .center
        return label
    }
}

//MARK: - Styling
extension ItemDetailViewController {
    
    func styleTableView() {
        navigationController?.navigationBar.prefersLargeTitles = false
        
    }
}

//MARK: - Session Detail Controller Delegate Methods
extension ItemDetailViewController: SessionDetailViewControllerDelegate {
    func SessionDetailViewController(_ controller: SessionDetailViewController, didFinishAddingMajorScale scale: String) {
        majorScaleTextField.text = scale
        navigationController?.popViewController(animated: true)
    }
    
    func SessionDetailViewController(_ controller: SessionDetailViewController, didFinishAddingMinorScale scale: String) {
        minorScaleTextField?.text = scale
        navigationController?.popViewController(animated: true)
    }
    
    func SessionDetailViewController(_ controller: SessionDetailViewController, didFinishAddingMainPiece content: String) {
        mainPieceTextField?.text = content
        navigationController?.popViewController(animated: true)
    }
    
    func SessionDetailViewController(_ controller: SessionDetailViewController, didFinishAddingSightReading content: String) {
        sightReadingTextField?.text = content
        navigationController?.popViewController(animated: true)
    }
    
    func SessionDetailViewController(_ controller: SessionDetailViewController, didFinishAddingImprovisation content: String) {
        improvisationTextField?.text = content
        navigationController?.popViewController(animated: true)
    }
    
    func SessionDetailViewController(_ controller: SessionDetailViewController, didFinishAddingRepertoire content: String) {
        repertoireTextField?.text = content
        navigationController?.popViewController(animated: true)
    }
}





