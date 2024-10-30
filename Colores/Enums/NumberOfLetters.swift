//
//  NumberOfLetters.swift
//  Colores
//
//  Created by Santi Ochoa on 9/28/24.
//

import Foundation

enum NumberOfLetters: String, CaseIterable, Identifiable {
  
  var id: String { self.rawValue }
  
  case long
  case mini
  
  var number: Int {
    switch self {
    case .long: return 6
    case .mini: return 3
    }
  }
  
  var systemImage: String {
    switch self {
    case .long: return "6.circle"
    case .mini: return "3.circle"
    }
  }
}
