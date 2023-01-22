//
//  Utility.swift
//  Lento
//
//  Created by Jacob Case on 1/10/23.
//

import Foundation
import UIKit


let applicationDocumentsDirectory: URL = {
    let paths = FileManager.default.urls(
    for: .documentDirectory,
    in: .userDomainMask)
  return paths[0]
}()

/*
 
 https://stackoverflow.com/questions/35700281/date-format-in-swift
 https://stackoverflow.com/questions/24070450/how-to-get-the-current-time-as-datetime
 */


func formatDateToString(date: Date) -> String {
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    let inputDate = formatter.string(from: date)
    //print(inputDate)
    
    return inputDate
}

func formatDateToMonthSeparator(date: Date) -> String {
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM YYYY"
        return formatter
    }()
    
    let inputDate = formatter.string(from: date)
    //print(inputDate)
    
    return inputDate
}

func formatStringToDate(dateString: String) -> Date? {
    let formatter = DateFormatter()
    
    guard let date = formatter.date(from: dateString) else {return Date()}
        
    return date
}

func formatSectionDate(oldDate: Date) -> Date? {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.month, .year], from: oldDate)
    let date = calendar.date(from: components)
    
    
    return date
}

func formatSessionDate(oldDate: Date) -> Date? {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.day, .month, .year], from: oldDate)
    let date = calendar.date(from: components)
    
    return date
}



