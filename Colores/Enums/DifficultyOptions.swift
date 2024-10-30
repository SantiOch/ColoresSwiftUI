//
//  DifficultyOptions.swift
//  Colores
//
//  Created by Santi Ochoa on 9/27/24.
//
import SwiftUI

enum DifficultyOptions: String, CaseIterable, Identifiable {
  
  var id: String { self.rawValue }
  
  case easy
  case medium
  case hard
  
  var systemImage: String {
    switch self {
    case .easy: return "figure.stand"
    case .medium: return "figure.walk"
    case .hard: return "figure.run"
    }
  }
}
