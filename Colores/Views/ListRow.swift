//
//  ListRow.swift
//  Colores
//
//  Created by Santi Ochoa on 9/23/24.
//
import SwiftUI

struct ListRow: View {
  
  @EnvironmentObject var vm: ColoresViewModel
  
  var guess: String
  var colorToGuess: String
  
  var body: some View {
    HStack (alignment: .center) {
      Spacer()
      ForEach(Array(guess.enumerated()), id: \.offset) { index, character in
        individualLetter(index: index, letter: character)
      }
      Spacer()
    }
  }
  
  func individualLetter(index: Int, letter: Character) -> some View {
    VStack {
      Text(String(letter))
        .font(.title)
        .padding(.vertical, 3)
      
      let letterToGuess = Array(colorToGuess)[index]
      
      vm.getImage(for: letter, letterToGuess: letterToGuess)
        .bold()
    }
    .frame(width: 20, height: 80)
    .padding(.horizontal)
    .background(
      RoundedRectangle(cornerRadius: 10)
        .stroke(Color(hex: guess), lineWidth: 10)
        .background(Color(.systemGray5))
    )
    .clipShape(RoundedRectangle(cornerRadius: 10))
  }
}

#Preview {
  NavigationStack {
    LatestGamesView()
      .environmentObject(ColoresViewModel())
  }
}
