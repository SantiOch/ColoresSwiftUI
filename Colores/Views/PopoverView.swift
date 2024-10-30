//
//  PopoverView.swift
//  Colores
//
//  Created by Santi Ochoa on 9/23/24.
//

import SwiftUI

struct PopoverView: View {
  
  var color: Color
  
  public var body: some View {
    HStack (spacing: 15) {
      Image(systemName: "number")
        .resizable()
        .bold()
        .foregroundColor(color.opacity(0.8))
        .frame(width: 30, height: 30)
      VStack(alignment: .leading, spacing: 2) {
        Text("Color no válido")
          .font(.subheadline)
          .bold()
          .foregroundColor(color)
          .padding(.top, 5)
        Text("Introduce un codigo de color válido con caracteres hexadecimales")
          .font(.subheadline)
          .padding(.bottom, 5)
      }
    }
    .presentationCompactAdaptation((.popover))
  }
}

#Preview {
  ContentView()
    .environmentObject(ColoresViewModel.shared)
}
