//
//  StatsViewController.swift
//  Lento
//
//  Created by Jacob Case on 1/19/23.
//

import UIKit
import Charts

public class customBarDataSet: ChartBaseDataSet {
    let newDataSet = ChartBaseDataSet()
    
}

class StatsViewController: UIViewController, ChartViewDelegate {
    
    var months:[String] = []
      
    lazy var barChartView: BarChartView = {
        let chartView = BarChartView()
        chartView.backgroundColor = .systemGray
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
        chartView.xAxis.labelPosition = .bottom
        return chartView
    }()
    
    var yValues: [ChartDataEntry] = []
    
    var pSessions: [PracticeSession]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("here")
        

        pSessions = CoreDataManager.shared.fetchSortedPracticeSessionsByDate()
        
        //setData()
        barChartView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width)
        view.addSubview(barChartView)
        barChartView.center = view.center
        stageData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("update chart")
        barChartView.clear()
        pSessions.removeAll()
        yValues.removeAll()
        pSessions = CoreDataManager.shared.fetchPracticeSessions()
        
        //setData()
        stageData()
        barChartView.notifyDataSetChanged()
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    
    func stageData() {
        let dataSet = BarChartDataSet(entries: yValues)
        dataSet.colors = ChartColorTemplates.joyful()
        let data = BarChartData(dataSet: dataSet)
        barChartView.data = data
    }
    
    
//    func setData() {
//        months.removeAll()
//        for (i, d) in pSessions.enumerated()  {
//            print(formatDateToString(date: d.date!))
//            months.insert(formatDateToString(date: d.date!), at: i)
//            let entry = BarChartDataEntry(x: Double(i), y: Double(d.minutes))
//            yValues.append(entry)
//        }
//    }
    
    

}
