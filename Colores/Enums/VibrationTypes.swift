//
//  VibrationTypes.swift
//  Colores
//
//  Created by Santi Ochoa on 9/27/24.
//
import SwiftUI

enum VibrationTypes: String, CaseIterable, Identifiable {
  
  var id: String { self.rawValue }
  
  case light
  case medium
  case heavy
  case rigid
  case soft
  
  var feedback: UIImpactFeedbackGenerator.FeedbackStyle {
    switch self {
    case .heavy: return .heavy
    case .light: return .light
    case .medium: return .medium
    case .rigid: return .rigid
    case .soft: return .soft
    }
  }
  
  var systemImage: String {
    switch self {
    case .light: return "exclamationmark"
    case .medium: return "exclamationmark.2"
    case .heavy: return "exclamationmark.3"
    case .rigid: return "mountain.2"
    case .soft: return "cloud"
    }
  }
}
