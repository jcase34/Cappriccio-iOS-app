//
//  AnalyticsViewController.swift
//  Lento
//
//  Created by Jacob Case on 1/23/23.
//

import UIKit
import Charts

class AnalyticsViewController: UITableViewController, ChartViewDelegate {

    @IBOutlet weak var ChartDateLabel: UILabel!
    @IBOutlet weak var sevenDayPracticeBarChartView: UIView!
    lazy var barChartView: BarChartView = {
        let chartView = BarChartView()
        chartView.backgroundColor = .systemGray
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: days)
        chartView.rightAxis.enabled = false
        chartView.isUserInteractionEnabled = false
        chartView.legend.enabled = false
        
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
    var dayIndexDictionary = [Int:Int]() //e.g day (15) : minutes (30)
    var dataEntries = [ChartDataEntry]()
    var weeklyData: [Int16] = [0,0,0,0,0,0,0]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("refresh chart")
        //fetch all sessions and organize by date. Later fix with a fetch limit up to 20 or so
        pSessions = CoreDataManager.shared.fetchSortedPracticeSessionsByDate()!
        print(pSessions.isEmpty)
        createBarChartFromData()
    }
}


//MARK: - Bar Chart View Control
extension AnalyticsViewController  {
    
    func fetchDataforChartEntries() {
        for (n,x) in getLastSevenDayInts().reversed().enumerated() {
            dayIndexDictionary[x] = n
        }
        for p in pSessions {
            if let date = p.sessionDate {
                if dayIndexDictionary.keys.contains(convertDateToDayInteger(oldDate: date)) {
                    weeklyData[dayIndexDictionary[convertDateToDayInteger(oldDate: date)]!] += p.minutes
                }
            }
        }
//        print("Weekly data contains days:minutes: \(weeklyData)")
    }
    
    func createDataEntries() {
        for (index,val) in weeklyData.enumerated()  {
            let entry = BarChartDataEntry(x: Double(index), y: Double(val))
            dataEntries.append(entry)
        }
        
    }
    
    
    func assignDataEntries() {
        print(dataEntries)
        let dataSet = BarChartDataSet(entries: dataEntries)
        dataSet.setColor(NSUIColor(red: 15.0/255.0, green: 100.0/255.0, blue: 50/255.0, alpha: 1.0))
        let data = BarChartData(dataSet: dataSet)
        barChartView.data = data
    }
    
    func createBarChartFromData() {
        weeklyData = [0,0,0,0,0,0,0]
        barChartView.data?.clearValues()
        dataEntries.removeAll()
        
        if !pSessions.isEmpty {
            print("data in sessions")
            fetchDataforChartEntries()
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
        barChartView.animate(xAxisDuration: 0.3)
        barChartView.animate(yAxisDuration: 0.3)
    }
    
}
