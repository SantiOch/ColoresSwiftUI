//
//  DifficultyHelpView.swift
//  Colores
//
//  Created by Santi Ochoa on 10/30/24.
//

import SwiftUI

public struct DifficultyHelpView: View {
  
  @Environment(\.dismiss) var dismiss
  let spacing: CGFloat = 40
  
  public var body: some View {
    ScrollView {
      
      Spacer(minLength: 10)
      
      Text("The difficulty levels are: Easy, Medium and Hard.")
           
      Spacer(minLength: 20)
     
      Text("Easy Mode")
        .font(.headline)

      Spacer(minLength: spacing / 3)
      
      Text("In easy, there will be three different indicators for the current guess, one showing that the number is correct, other showing that the number is off by less than three digits and the last showing that the number is off by more than three digits all showing if the guessed number is higher or lower than the actual number.")

      Spacer(minLength: spacing / 2)
      
      ListRow(guess: "A12AF7", colorToGuess: "5139AF", difficultyOption: .easy)

      Spacer(minLength: spacing)
      
      Text("Medium Mode")
        .font(.headline)

      Spacer(minLength: spacing / 3)
      
      Text("In medium, there will be two different indicators for the current guess, one showing that the number is correct, and the other showing that the number is higher or lower than the actual number.")
      
      Spacer(minLength: spacing / 2)

      ListRow(guess: "1169AF", colorToGuess: "5139AF", difficultyOption: .medium)
      
      Spacer(minLength: spacing)
      
      Text("Hard Mode")
        .font(.headline)

      Spacer(minLength: spacing / 3)
      
      Text("In hard, there will be one indicator for the current guess, showing if the number is correct or not.")
      
      Spacer(minLength: spacing / 2)

      ListRow(guess: "5F339F", colorToGuess: "5139AF", difficultyOption: .hard)
      
      Spacer(minLength: spacing)
      
    }
    .toolbar {
      ToolbarItem(placement: .confirmationAction) {
        Button {
          dismiss()
        } label: {
          Text("Close")
            .bold()
        }
      }
    }
    .scrollIndicators(.hidden)
    .ignoresSafeArea(edges: .bottom)
    .padding(.horizontal, 15)
    .navigationTitle("Difficulty Help")

  }
}

#Preview {
  DifficultyHelpView()
    .environmentObject(ColoresViewModel())
}
