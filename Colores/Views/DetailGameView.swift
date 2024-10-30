//
//  DetailGameView.swift
//  Colores
//
//  Created by Santi Ochoa on 9/26/24.
//
import SwiftUI

struct DetailGameView: View {
  
  @Environment(\.dismiss) var dismissVar
    
  @EnvironmentObject var vm: ColoresViewModel
  
  @State private var selectedGuess: String? = nil
      
  func dismiss() { dismissVar() }
  
  let game: Game

  var body: some View {
    VStack {
      TopRectanglesView(colorToGuess: game.colorToGuess,
                        currentColorGuessed: selectedGuess ?? game.colorToGuess)

      List {
        ForEach(game.allGuesses.reversed(), id: \.self) { guess in
          HStack {
            Spacer()
            ListRow(guess: guess, colorToGuess: game.colorToGuess)
              .modifier(ListRowModifier(guess: guess,
                                        selectedGuess: selectedGuess,
                                        action: toggleGuess))
            Spacer()
          }
          .listRowSeparator(.hidden)
        }
      }
      .listStyle(.plain)
    }
    .navigationBarBackButtonHidden()
    .toolbar {
      ToolbarItem(placement: .topBarLeading) {
        Button(action: dismiss) {
          HStack (spacing: 3) {
            Image(systemName: "chevron.left")
            Text("Back")
          }
        }
        .bold()
        .tint(vm.selectedColorOption.color)
      }
    }
  }
  
  func toggleGuess(_ guess: String) {
    withAnimation {
      if selectedGuess != guess {
        selectedGuess = guess
      }
      else {
        selectedGuess = nil
      }
    }
    vm.playHaptic()
  }
}

