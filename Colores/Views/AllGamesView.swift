//
//  AllGamesView.swift
//  Colores
//
//  Created by Santi Ochoa on 11/1/24.
//

import SwiftUI
import SwiftData

struct AllGamesView: View {
  
  @Environment(\.modelContext) var modelContext
  
  @EnvironmentObject var vm: ColoresViewModel
  
#if targetEnvironment(simulator)
  var games: [Game] = [
    .init(colorToGuess: "543432", allGuesses: ["543", "532", "963"], length: 6),
    .init(colorToGuess: "543432", allGuesses: ["543", "532", "963"], length: 6),
    .init(colorToGuess: "543432", allGuesses: ["543", "532", "963"], length: 6),
    .init(colorToGuess: "543432", allGuesses: ["543", "532", "963"], length: 6),
    .init(colorToGuess: "543432", allGuesses: ["543", "532", "963"], length: 3),
    .init(colorToGuess: "543432", allGuesses: ["543", "532", "963"], length: 3),
    
  ]
#else
  var games: [Game]
#endif
  
  var sortedGames: [Game] { games.sorted { $0.date > $1.date } }
  
  var body: some View {
    NavigationStack {
      VStack {
        List {
          Section {
            ForEach(games) { game in
              NavigationLink {
                DetailGameView(game: game)
              } label: {
                listRowLabel(game)
              }
            }
          } header: {
            Text("\(games.first?.length == 3 ? "Three" : "Six") letter games")
          }
          
          Section {
            Button(action: deleteGames) {
              Label("Delete all games", systemImage: "trash")
                .foregroundStyle(vm.selectedColorOption.color ?? .red)
            }
          } header: {
            Text("Delete all games")
          } footer: {
            Text("This will delete all games from the device. This action cannot be undone.")
          }
        }
        
      }
      .animation(.default, value: sortedGames)
      .navigationTitle("All Games")
      .navigationBarTitleDisplayMode(.inline)
    }
  }
  
  @ViewBuilder
  func listRowLabel(_ game: Game) -> some View {
    HStack {
      HexColoredRectangle(hexColor: game.colorToGuess,
                          width: 40,
                          height: 40,
                          cornerRadius: 5,
                          padding: 2)
      Text("#\(game.colorToGuess)")
        .bold()
    }
  }
  
  func deleteGames() {
    modelContext.deleteAll(games)
  }
}

#Preview {
  LatestGamesView()
    .environmentObject(ColoresViewModel.shared)
}
