//
//  ColorOptions.swift
//  Colores
//
//  Created by Santi Ochoa on 9/27/24.
//
import SwiftUI

enum ColorOptions: String, CaseIterable, Identifiable {
  
  var id: String { self.rawValue }
  
  case indigo
  case blue
  case mint
  case green
  case brown
  case red
  case pink
  case orange
//  case yellow
  case device
  
  var color: Color? {
    switch self {
    case .indigo: return .indigo
    case .red: return .red
    case .green: return .green
    case .mint: return .mint
    case .blue: return .blue
    case .pink: return .pink
    case .brown: return .brown
//    case .yellow: return .yellow
    case .orange: return .orange
    case .device: return nil
    }
  }
  
  var title: String {
    switch self {
    case .device: return "Default"
    default : return self.rawValue.capitalized
    }
  }
}

#Preview {
  ForEach(ColorOptions.allCases) { color in
    Label(title: { Text(color.title) }, icon: { CircledImage(color: color.color) })
  }
}
