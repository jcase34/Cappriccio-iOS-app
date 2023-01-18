//
//  Scales.swift
//  Lento
//
//  Created by Jacob Case on 1/9/23.
//

import Foundation


enum MajorScale: String, CaseIterable {
    case none = "None"
    case C = "C-major"
    case G = "G-major"
    case D = "D-major"
    case A = "A-major"
    case E = "E-major"
    case B = "B-major"
    case Fsharp = "F♯-major"
    case Csharp = "C♯-major"
    case F = "F-major"
    case Bflat = "B♭-major"
    case Eflat = "E♭-major"
    case Aflat = "A♭-major"
    case Dflat = "D♭-major"
    case Gflat = "G♭-major"
    case Cflat = "C♭-major"
}

enum MinorScale: String, CaseIterable {
    case none = "None"
    case A = "A-minor"
    case E = "E-minor"
    case B = "B-minor"
    case Fsharp = "F♯-minor"
    case Csharp = "C♯-minor"
    case Gsharp = "G♯-minor"
    case Dsharp = "D♯-minor"
    case Asharp = "A♯-minor"
    case D = "D-minor"
    case G = "G-minor"
    case C = "C-minor"
    case F = "F-minor"
    case Bflat = "B♭-minor"
    case Eflat = "E♭-minor"
    case Aflat = "A♭-minor"
}

func getMajorScaleTitles() -> [String] {
    var scales = [String]()
    for scale in MajorScale.allCases {
        scales.append(scale.rawValue)
    }
    return scales
}

func getMinorScaleTitles() -> [String] {
    var scales = [String]()
    for scale in MinorScale.allCases {
        scales.append(scale.rawValue)
    }
    return scales
}

func getScaleCount() -> Int {
    return MajorScale.allCases.count
}

