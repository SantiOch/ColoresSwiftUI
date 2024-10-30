//
//  Modifiers.swift
//  Colores
//
//  Created by Santi Ochoa on 9/23/24.
//

import SwiftUI
import Foundation
import Combine

struct GuessModifier: ViewModifier {
  
  @Binding var pin : String
  var color: Color?
  
  var textLimt: Int
  
  func limitText(_ upper : Int) {
    self.pin = self.pin.uppercased()
    if pin.count > upper {
      self.pin = String(pin.prefix(upper))
    }
  }
  
  func body(content: Content) -> some View {
    content
      .multilineTextAlignment(.center)
      .onReceive(Just(pin)) {_ in limitText(textLimt)}
      .padding()
      .frame(width: 220, height: 40)
      .background {
        RoundedRectangle(cornerRadius: 5)
          .stroke( color ?? .blue, lineWidth: 3)
          .background(.gray.opacity(0.5))
      }
  }
}
