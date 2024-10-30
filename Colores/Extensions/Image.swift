//
//  Image.swift
//  Colores
//
//  Created by Santi Ochoa on 9/26/24.
//
import SwiftUI

struct CircledImage: View {
  
  let color: Color?
  
  var body: some View {
      if let color {
        Image(size: CGSize(width: 20, height: 20)) { ctx in 
          ctx.fill(
            Path(
              roundedRect: CGRect(origin: .zero, size: CGSize(width: 20, height: 20)),
              cornerRadius: 10
            ),
            with: .color(color)
          )
        }
      } else {
        Image(systemName: "iphone.gen3")
      }
  }
}

extension Image {
  
  @ViewBuilder
  func endingScreenModifier(win: Bool) -> some View {
    self
      .resizable()
      .font(.title)
      .foregroundColor(win ? .green : .red)
      .frame(width: 70, height: 70)
      .padding(65)
      .background(.thinMaterial)
      .clipShape(RoundedRectangle(cornerRadius: 10))
      .symbolEffect(.bounce, options: .nonRepeating)
      
  }
}

#Preview {
  ContentView()
    .environmentObject(ColoresViewModel())
}
