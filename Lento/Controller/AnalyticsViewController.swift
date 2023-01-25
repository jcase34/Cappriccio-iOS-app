//
//  AnalyticsViewController.swift
//  Lento
//
//  Created by Jacob Case on 1/23/23.
//

import UIKit
import Charts


class myValueFormatter : IndexAxisValueFormatter {
    override func stringForValue( _ value: Double, axis _: AxisBase?) -> String {
        var dateMatches = [Double:String]()
        let cal = Calendar.current
        var date = cal.startOfDay(for: Date())
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        for i in 1...7 {
            let day = Double(cal.component(.day, from: date))
            dateMatches[day] = formatter.string(from: date)
            date = cal.date(byAdding: .day, value: -1, to: date)!
        }
        
        if dateMatches.keys.contains(value) {
            return dateMatches[value]!
        } else {
            return ""
        }
    }
}


class AnalyticsViewController: UITableViewController {

    @IBOutlet weak var practiceBarChartView: UIView!
    lazy var barChartView: BarChartView = {
        let chartView = BarChartView()
        chartView.backgroundColor = .systemGray
        chartView.xAxis.valueFormatter = myValueFormatter()
        chartView.rightAxis.enabled = false
        chartView.isUserInteractionEnabled = false
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.granularity = 1.0
        xAxis.drawGridLinesEnabled = false
        
        
        let yAxis = chartView.leftAxis
        yAxis.labelPosition = .outsideChart
        yAxis.axisMinimum = 0
        
        
        
        return chartView
    }()
    
    var pSessions = [PracticeSession]()
    var lastSevenDates = [Date:Int16]()
    var weeklyData = [Int:Int16]()
    var yMinutes = [ChartDataEntry]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        barChartView.frame = CGRect(x: 0, y: 0, width: practiceBarChartView.frame.width, height: practiceBarChartView.frame.height)
        barChartView.center
        lastSevenDates = getLastSevenDayDates()
        //print(lastSevenDaysData)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        
        pSessions = CoreDataManager.shared.fetchSortedPracticeSessionsByDate()!
        for p in pSessions {
            if let date = p.sessionDate {
                if lastSevenDates.keys.contains(date) {
                    weeklyData[Calendar.current.component(.day, from: date)] = p.minutes
                }
            }
        }
        
        print(weeklyData)
        setData()
        stageData()
        practiceBarChartView.addSubview(barChartView)
        barChartView.animate(xAxisDuration: 1)
        barChartView.animate(yAxisDuration: 1)
    }
}


//MARK: - Bar Chart View Control
extension AnalyticsViewController {
    func setData() {
        for (key,value) in weeklyData  {
            let entry = BarChartDataEntry(x: Double(key), y: Double(value))
            yMinutes.append(entry)
        }
        print(yMinutes)
    }
    
    
    func stageData() {
        let dataSet = BarChartDataSet(entries: yMinutes)
        dataSet.colors = ChartColorTemplates.joyful()
        let data = BarChartData(dataSet: dataSet)
        barChartView.data = data
    }
    
}
