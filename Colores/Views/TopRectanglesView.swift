//
//  TopRectanglesView.swift
//  Colores
//
//  Created by Santi Ochoa on 9/24/24.
//

import SwiftUI

struct TopRectanglesView: View {
    
  var colorToGuess: String
  var currentColorGuessed: String
  var width: CGFloat = 150
  var height: CGFloat = 150
  var cornerRadius: CGFloat = 10
  var padding: CGFloat = 5
  
  var body: some View {
    HStack {
      VStack {
        Text("Target")
          .bold()
        HexColoredRectangle(hexColor: colorToGuess, width: width, height: height, cornerRadius: cornerRadius, padding: padding)
      }
      VStack {
        Text("Your Guess")
          .bold()
        HexColoredRectangle(hexColor: currentColorGuessed, width: width, height: height, cornerRadius: cornerRadius, padding: padding)
      }
    }
  }
}

struct HexColoredRectangle: View {
  
  @EnvironmentObject var vm: ColoresViewModel
  
  var hexColor: String
  var width: CGFloat = 150
  var height: CGFloat = 150
  var cornerRadius: CGFloat = 10
  var padding: CGFloat = 5
  
  var body: some View {
    RoundedRectangle(cornerRadius: cornerRadius)
      .fill(Color(hex: hexColor))
      .frame(width: width, height: height)
      .padding(padding)
      .background(vm.selectedColorOption.color ?? .gray)
      .clipShape(RoundedRectangle(cornerRadius: cornerRadius + padding))
      .padding(2)
  }
}
