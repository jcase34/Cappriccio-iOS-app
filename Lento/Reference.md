#  Reference docs for incorporating some features.

### CoreData Methods, structure of data, and utilization
-First need to define a proper entity to be saved within coreData object model
let pSession = NSEntityDescription.insertNewObject(forEntityName: K.practiceSession, into: managedContext) as! PracticeSession

-Above is an outline for what we're wanting to insert, but haven't done anything with it yet. It's an instantiation.
-Add properties to the object
pSession.date = Date()
pSession.minutes = 5

-Call on the manager to save data. Most liklely will use propogated managedContext in the future
-By propogating the managedContext, we can perform a save/update/delete at any time.
CoreDataManager.saveNewSession(session: pSession, sessions: &practiceSessions)

### FRC/Core Data
https://stackoverflow.com/questions/48254060/how-to-use-nsfetchedresultscontroller-to-update-tableview-content

### Table view quirks
-For inserting a new item into a table

-Get current count of items in some array that's being referenced
let newRowIndex = practiceSessions.count

-append a new item to the array
practiceSessions.append(pSession)

-Create an indexPath object that references the current amount of items count
let indexPath = IndexPath(row: newRowIndex, section: 0)

-insert the index path of the referenced counted items into the tableview 
-(i.e table view grows in reference to the amount of objects within items array)
let indexPaths = [indexPath]
tableView.insertRows(at: indexPaths, with: .fade)

### Picker View Delegate Details
//MARK: - Picker View Delegate
extension ItemDetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return getScaleCount()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 10 {
            let scales = getMajorScaleTitles()
            return scales[row]
        } else if pickerView.tag == 11 {
            let scales = getMinorScaleTitles()
            return scales[row]
        } else {
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if pickerView.tag == 10 {
            let scales = getMajorScaleTitles()
            var label = UILabel()
            if let view = view as? UILabel {
                label = view
            }
            label.font = UIFont(name: "Helvetica Neue", size: 14)
            label.text = scales[row]
            label.textAlignment = .center
            return label
            
        } else if pickerView.tag == 11 {
            let scales = getMinorScaleTitles()
            var label = UILabel()
            if let view = view as? UILabel {
                label = view
            }
            label.font = UIFont(name: "Helvetica Neue", size: 14)
            label.text = scales[row]
            label.textAlignment = .center
            
            return label
        } else {
            return UIView()
        }
    }
}
