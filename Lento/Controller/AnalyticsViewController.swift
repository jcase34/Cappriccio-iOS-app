//
//  AnalyticsViewController.swift
//  Lento
//
//  Created by Jacob Case on 1/23/23.
//

import UIKit
import Charts
import MessageUI

class AnalyticsViewController: UITableViewController, ChartViewDelegate, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var averageMinutesSevenDays: UILabel!
    @IBOutlet weak var ChartDateLabel: UILabel!
    @IBOutlet weak var sevenDayPracticeBarChartView: UIView!
    lazy var barChartView: BarChartView = {
        let chartView = BarChartView()
        chartView.backgroundColor = UIColor(named: "ChartBG")
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: days)
        chartView.rightAxis.enabled = false
        chartView.isUserInteractionEnabled = false
        chartView.legend.enabled = false
        chartView.noDataText = "No Practice Data Available"
        chartView.noDataFont = .boldSystemFont(ofSize: 14)
        
        //configure xAxis
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.granularity = 1.0
        xAxis.drawGridLinesEnabled = false
        xAxis.labelFont = .boldSystemFont(ofSize: 12)

        
        //configure yAxis
        let yAxis = chartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
        yAxis.labelPosition = .outsideChart
        yAxis.axisMinimum = 0
        yAxis.granularity = 5
        yAxis.setLabelCount(10, force: false)
        
        
        return chartView
    }()
    
    public let days: [String] = {
        var days = [String]()
        let cal = Calendar.current
        var date = cal.startOfDay(for: Date())
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        for _ in 1...7 {
            //day is the calendar component of current date
            let day = Double(cal.component(.day, from: date))
            let formattedDay = formatter.string(from: date)
            date = cal.date(byAdding: .day, value: -1, to: date)!
            days.append(formattedDay)
            
        }
        return days.reversed()
    }()
    
    var pSessions: [PracticeSession] = []
    var dayIndexDictionary = [Int:Int]() //e.g day (15) : index(5)
    var dataEntries = [ChartDataEntry]()
    var weeklyData: [Int16] = [0,0,0,0,0,0,0]
    var sessionCount = 1
    var dataInLastSevenDays = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("refresh chart")
        //fetch all sessions and organize by date. Later fix with a fetch limit up to 20 or so
        pSessions = CoreDataManager.shared.fetchSortedPracticeSessionsByDate()!
        print(pSessions)
        print(pSessions.isEmpty)
        createBarChartFromData()
        let weekMinutes = Int(weeklyData.reduce(0, +))
        print(weekMinutes)
        print(sessionCount)
        let average = weekMinutes / sessionCount
        print(weeklyData)
        averageMinutesSevenDays.text = "Average Session Time: \(average) minutes"
    }
    
    
    @IBAction func exportSevenDaySessionsButton(_ sender: UIButton) {
        createAndExportCSV()
        //deleteFileInCache()
    }
}

//MARK: - Create & Share Data
extension AnalyticsViewController {
    
    func createAndExportCSV() {
        let fileName = "PastSevenDayHistory.csv"
        
        guard let path = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(fileName) as NSURL else {
            return  }

        var csvText = "date,minutes,major scale, minor scale, mainpiece, sight reading, improvisation, repertoire\n"
        
        
        
        for p in pSessions {
            if let date = p.sessionDate {
                if dayIndexDictionary.keys.contains(convertDateToDayInteger(oldDate: date)) {
                    let newLine = "\(String(describing: p.sessionDate!)),\(p.minutes),\(String(describing: p.majorScale!)),\(String(describing: p.minorScale!)),\(String(describing: p.mainPiece!)),\(String(describing: p.sightReading!)),\(String(describing: p.improvisation!)),\(String(describing: p.reportoire!))\n"
                    csvText.append(newLine)
                }
            }
        }
        
        //write to text file & send
        do {
            try csvText.write(to: path as URL, atomically: true, encoding: String.Encoding.utf8)
            print("Success in exporting csv file")
            print("File path: \(path)")
            let vc = UIActivityViewController(activityItems: [path], applicationActivities: [])
                            vc.excludedActivityTypes = [
                                UIActivity.ActivityType.assignToContact,
                                UIActivity.ActivityType.saveToCameraRoll,
                                UIActivity.ActivityType.postToFlickr,
                                UIActivity.ActivityType.postToVimeo,
                                UIActivity.ActivityType.postToTencentWeibo,
                                UIActivity.ActivityType.postToTwitter,
                                UIActivity.ActivityType.postToFacebook,
                                UIActivity.ActivityType.openInIBooks
                            ]
            present(vc, animated: true, completion: nil)
            
        } catch {
            print("Failed to create file")
            print("\(error)")
        }
    }
    
    func deleteFileInCache() {
        
        let fileManager = FileManager.default
        let documentsUrl =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first! as NSURL
        let documentsPath = documentsUrl.path
        do {
            if let documentPath = documentsPath
            {
                let fileNames = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
                print("all files in cache: \(fileNames)")
                for fileName in fileNames {
                    print(fileName)
                    // delete file
                    do {
                        try FileManager.default.removeItem(atPath: fileName)
                        print("success deleting file")
                    } catch {
                        print("Could not delete file, probably read-only filesystem")
                    }
                }
            }
        } catch {
            print(error)
        }
    }

}


//MARK: - Bar Chart View Control
extension AnalyticsViewController  {
    
    func fetchDataforChartEntries() {
        for (n,x) in getLastSevenDayInts().reversed().enumerated() {
            dayIndexDictionary[x] = n
        }
        
        sessionCount = 0
        
        for p in pSessions {
            if let date = p.sessionDate {
                if dayIndexDictionary.keys.contains(convertDateToDayInteger(oldDate: date)) {
                    weeklyData[dayIndexDictionary[convertDateToDayInteger(oldDate: date)]!] += p.minutes
                    sessionCount += 1
                }
            }
        }
        
        if sessionCount == 0 {
            print("No data for last 7 days")
            dataInLastSevenDays = false
            sessionCount = 1
        } else {
            dataInLastSevenDays = true
        }
        
        print("Weekly data contains days:minutes: \(weeklyData)")
    }
    
    func createDataEntries() {
        for (index,val) in weeklyData.enumerated()  {
            let entry = BarChartDataEntry(x: Double(index), y: Double(val))
            dataEntries.append(entry)
        }
    }
    
    func assignDataEntries() {
        print("colorizing entries")
        print(dataEntries)
        
        
//        let dataSet = BarChartDataSet(entries: dataEntries, label: "Minutes")
//        dataSet.setColor(NSUIColor(red: 15.0/255.0, green: 100.0/255.0, blue: 50/255.0, alpha: 0.5))
        
        let day0 = BarChartDataSet(entries: [dataEntries[0]], label: "Minutes")
        day0.setColor(UIColor(named: "GreenBarDark")!)
        
        let day1 = BarChartDataSet(entries: [dataEntries[1]], label: "Minutes")
        day1.setColor(UIColor(named: "GreenBarLight")!)
        
        let day2 = BarChartDataSet(entries: [dataEntries[2]], label: "Minutes")
        day2.setColor(UIColor(named: "GreenBarDark")!)
        
        let day3 = BarChartDataSet(entries: [dataEntries[3]], label: "Minutes")
        day3.setColor(UIColor(named: "GreenBarLight")!)
        
        let day4 = BarChartDataSet(entries: [dataEntries[4]], label: "Minutes")
        day4.setColor(UIColor(named: "GreenBarDark")!)
        
        let day5 = BarChartDataSet(entries: [dataEntries[5]], label: "Minutes")
        day5.setColor(UIColor(named: "GreenBarLight")!)
        
        let day6 = BarChartDataSet(entries: [dataEntries[6]], label: "Minutes")
        day6.setColor(UIColor(named: "GreenBarDark")!)
        
        let data: BarChartData = [day0, day1, day2, day3, day4, day5, day6]
        barChartView.data = data
    }
    
    func createBarChartFromData() {
        weeklyData = [0,0,0,0,0,0,0]
        barChartView.data?.clearValues()
        dataEntries.removeAll()
        
        fetchDataforChartEntries()
        
        if (dataInLastSevenDays) {
            print("data in sessions")
            createDataEntries()
            assignDataEntries()

        } else {
            barChartView.data = .none
        }
        
        barChartView.notifyDataSetChanged()
        barChartView.frame = CGRect(x: 0, y: 0, width: sevenDayPracticeBarChartView.frame.width, height: sevenDayPracticeBarChartView.frame.height)
        sevenDayPracticeBarChartView.addSubview(barChartView)
        sevenDayPracticeBarChartView.clipsToBounds = true
        barChartView.data?.setDrawValues(false)
        barChartView.animate(xAxisDuration: 0.1)
        barChartView.animate(yAxisDuration: 0.1)
    }
    
}
