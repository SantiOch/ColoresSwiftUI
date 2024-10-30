//
//  darkModeOptions.swift
//  Colores
//
//  Created by Santi Ochoa on 9/27/24.
//
import SwiftUI

enum DarkModeOptions: String, CaseIterable, Identifiable {
  
  var id: String { self.rawValue }
  
  case light
  case dark
  case system
  
  var userInterface: UIUserInterfaceStyle {
    switch self {
    case .light: return .light
    case .dark: return .dark
    case .system: return .unspecified
    }
  }
  
  var colorScheme: ColorScheme? {
    switch self {
    case .light: return .light
    case .dark: return .dark
    case .system: return nil
    }
  }
  
  var systemImage: String {
    switch self {
      case .light: return "sun.horizon"
      case .dark: return "moon.stars.fill"
      case .system: return "paintbrush"
    }
  }
}
