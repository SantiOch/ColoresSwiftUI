//
//  NumberOfGuesses.swift
//  Colores
//
//  Created by Santi Ochoa on 9/29/24.
//

import Foundation

enum NumberOfGuesses: String, CaseIterable, Identifiable {
  
  var id: String { self.rawValue }
  
  case one
  case two
  case three
  case four
  case five
  case six
  case seven
  case eight
  case nine
  case ten
  case unlimited
  
  var number: Int {
    switch self {
    case .one: return 1
    case .two: return 2
    case .three: return 3
    case .four: return 4
    case .five: return 5
    case .six: return 6
    case .seven: return 7
    case .eight: return 8
    case .nine: return 9
    case .ten: return 10
    case .unlimited: return Int.max
    }
  }
  
  var title: String {
    switch self {
    case .one: return "1"
    case .two: return "2"
    case .three: return "3"
    case .four: return "4"
    case .five: return "5"
    case .six: return "6"
    case .seven: return "7"
    case .eight: return "8"
    case .nine: return "9"
    case .ten: return "10"
    case .unlimited: return "No limit" 
    }
  }
}
