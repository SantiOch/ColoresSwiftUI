//
//  DifficultyHelpView.swift
//  Colores
//
//  Created by Santi Ochoa on 10/30/24.
//

import SwiftUI

public struct DifficultyHelpView: View {
  public var body: some View {
    VStack {
      Text("The difficulty levels are: Easy, Medium, Hard. In easy, there will be three different indicators for the current guess, one showing that the number is correct, other showing that the number is off by less than three digits and the last showing that the number is off by more than three digits all showing if the guessed number is higher or lower than the actual number. In medium, there will be two indicators for the current guess, one showing that the number is correct, other showing that the number is higher or lower. In hard, there will be one indicator for the current guess, showing if the number is correct or not.")
      
    }
    .navigationTitle("Difficulty Help")
  }
}
