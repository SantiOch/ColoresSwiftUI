//
//  ListRowExtension.swift
//  Colores
//
//  Created by Santi Ochoa on 9/23/24.
//
import SwiftUI

extension Image {
  
  static var doubleArrowUp: some View {
    ZStack {
      Image(systemName: "arrow.up")
      Image(systemName: "arrow.up")
        .offset(y: -5)
    }
  }
  
  static var doubleArrowDown: some View {
    ZStack {
      Image(systemName: "arrow.down")
      Image(systemName: "arrow.down")
        .offset(y: -5)
    }
  }
}
