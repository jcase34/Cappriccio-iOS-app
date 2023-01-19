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

func formatDate(date: Date) -> String {
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    let inputDate = formatter.string(from: date)
    print(inputDate)
    
    return inputDate
}

func organizeDatesToArray() {
    
}

