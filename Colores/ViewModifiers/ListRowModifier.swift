//
//  ListRowModifier.swift
//  Colores
//
//  Created by Santi Ochoa on 9/26/24.
//
import SwiftUI

struct ListRowModifier: ViewModifier {
  
  var guess: String
  var selectedGuess: String?
  var action: (String) -> Void
  
  func body(content: Content) -> some View {
    content
      .listRowSeparator(.hidden)
      .onTapGesture(perform: { action(guess) })
      .padding(.vertical, 7)
      .padding(8)
      .frame(width: guess.count == 3 ? 200 : 380)
      .background(selectedGuess == guess ? .gray.opacity(0.2): .clear,
                  in: RoundedRectangle(cornerRadius: 20))
      .contextMenu {
        Button(action: { action(guess) }) {
          let text = selectedGuess == guess ? "Unselect" : "Select"
          let image = selectedGuess == guess ? "xmark.circle.fill" : "checkmark.circle"
          Label(text, systemImage: image)
        }
      } preview: {
        ColorPreview(color: guess)
      }
  }
}

struct ColorPreview: View {
  
  var color: String
  
  var body: some View {
    ZStack(alignment: .bottom) {
      Color(hex: color)
    }
    .ignoresSafeArea()
    .safeAreaInset(edge: .bottom) {
      HStack {
        Spacer()
        Text("#\(color)")
          .font(.headline)
        Spacer()
      }
      .padding(5)
      .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 10))
    }
  .frame(width: 300, height: 300)
  }
}

#Preview {
  DetailGameView(game: Game(colorToGuess: "654", allGuesses: ["543", "534", "432"], length: 3))
    .environmentObject(ColoresViewModel())
}
