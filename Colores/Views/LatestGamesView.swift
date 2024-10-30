//
//  LatestGamesView.swift
//  Colores
//
//  Created by Santi Ochoa on 9/23/24.
//

import SwiftUI
import SwiftData

struct LatestGamesView: View {
  
  @Environment(\.dismiss) var dismissVar
  @Environment(\.modelContext) var modelContext

  @EnvironmentObject var vm: ColoresViewModel
  
#if targetEnvironment(simulator)
  var games: [Game] = [
    .init(colorToGuess: "543", allGuesses: ["543", "532", "963"], length: 3),
  ]
#else
  @Query var games: [Game]
#endif
  
  func dismiss() { dismissVar() }
  
  var sortedGames: [Game] { games.sorted { $0.date > $1.date } }
  
  var body: some View {
    NavigationStack {
      VStack {
        if !sortedGames.isEmpty {
          List {
            Section {
              ForEach(sortedGames.filterByLength(6)) { game in
                NavigationLink {
                  DetailGameView(game: game)
                } label: {
                  listRowLabel(game)
                }
              }
              if sortedGames.filterByLength(6).isEmpty {
                Text("No six letter games")
              }
            } header: {
              Text("Six letter games")
            }
            
            Section {
              ForEach(sortedGames.filterByLength(3)) { game in
                NavigationLink {
                  DetailGameView(game: game)
                } label: {
                  listRowLabel(game)
                }
              }
              if sortedGames.filterByLength(3).isEmpty {
                Text("No three letter games")
              }
            } header: {
              Text("Three letter games")
            }
            
            Section {
              Button(/*role: .destructive, */action: deleteGames) {
                Label("Delete all games", systemImage: "trash")
                  .foregroundStyle(vm.selectedColorOption.color ?? .red)
              }
            } header: {
              Text("Delete all games")
            } footer: {
              Text("This will delete all games from the device. This action cannot be undone.")
            }
          }
        } else {
          emptyGamesView()
       }
      }
      .animation(.default, value: sortedGames)
      .navigationTitle("Latest Games")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar(content: toolbarContent)
    }
  }
  
  func toolbarContent() -> some ToolbarContent {
    Group {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button("Close", action: dismiss)
          .bold()
          .tint(vm.selectedColorOption.color)
      }
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
  
  @ViewBuilder
  func emptyGamesView() -> some View {
    ContentUnavailableView {
      Label("No available games", systemImage: "list.bullet")
        .imageScale(.large)
    } description: {
      Text("Play some games in order to see the list of latest games played here and delete them.")
    } actions: {
      Button(action: dismiss) {
        Label("Close", systemImage: "xmark")
      }
      .bold()
      .tint(vm.selectedColorOption.color)
      .buttonStyle(.bordered)
    }
  }
  
  func deleteGames() {
    modelContext.deleteAll(games)
  }
}

extension [Game] {
  func filterByLength(_ length: Int) -> [Game] {
    self.filter { $0.length == length }
  }
}

#Preview {
    LatestGamesView()
      .environmentObject(ColoresViewModel.shared)
}

