//
//  ColoresApp.swift
//  Colores
//
//  Created by Santi Ochoa on 9/19/24.
//

import SwiftUI
import SwiftData

@main
struct ColoresApp: App {
  
  let vm = ColoresViewModel.shared
  
  var sharedModelContainer: ModelContainer  {
    let schema = Schema([ Game.self ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
    
    do {
      vm.changeStyleHandler()
      return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
      fatalError("Could not create ModelContainer: \(error)")
    }
  }
  
  var body: some Scene {
    WindowGroup {
      NavigationStack {
        ContentView()
          .environmentObject(vm)
          .modelContainer(sharedModelContainer)
      }
    }
  }
}
