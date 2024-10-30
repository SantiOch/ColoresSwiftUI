//
//  ContentView.swift
//  Colores
//
//  Created by Santi Ochoa on 9/19/24.
//

import SwiftUI
import Combine
import ConfettiSwiftUI

let hex = "ABCDEF0123456789"

struct ContentView: View {
   
  @EnvironmentObject var vm: ColoresViewModel
  @Environment(\.modelContext) var modelContext
  
  @State var counter: Int = 0
  @State var showLatestView: Bool = false
  @State var showSettingView: Bool = false
  @State var timerTime: Double?
  @State var isPlaying: Bool = false
  @FocusState var focus: Bool
  
  @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
  
  var body: some View {
    NavigationStack {
      VStack {
        
        TopRectanglesView(colorToGuess: vm.colorToGuess, currentColorGuessed: vm.currentColorGuessed, padding: 4)
        
        if vm.timerEnabled {
          Text("Time remaining: \(Int(timerTime ?? 0)) seconds")
            .bold()
        }
        
        Text("Enter a \(vm.selectedNumberOfLetters.number) Digit Hex Code")
          .font(.system(size: 16, weight: .bold))
        
        Text("\(vm.numberOfGuessesLeft()) \(vm.numberOfGuessesLeft() == "1" ? "guess" : "guesses") left")
          .font(.system(size: 13, weight: .bold))
          .bold()
        
        TextField("", text: $vm.currentGuess)
          .modifier(GuessModifier(pin: $vm.currentGuess, color: vm.selectedColorOption.color, textLimt: vm.selectedNumberOfLetters.number))
          .popover(isPresented: $vm.showPopover) { PopoverView(color: vm.selectedColorOption.color ?? .blue) }
          .focused($focus)
          .onSubmit(submitButtonActions)
        
        Button (action: submitButtonActions) {
          Label(vm.gameEnded ? vm.gameLost ? "Wrong! Try again" : "Correct! Next" :"Submit",
                systemImage: vm.gameEnded ? "arrow.right.circle" : "checkmark.circle")
            .bold()
            .padding()
            .frame(width: 200, height: 20)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding(.vertical, 5)
        .buttonStyle(.borderedProminent)
        .tint(vm.selectedColorOption.color)

        List {
          ForEach(vm.allGuesses.reversed(), id: \.self) { guess in
            ListRow( guess: guess, colorToGuess: vm.colorToGuess)
              .listRowSeparator(.hidden)
          }
        }
        .listStyle(.plain)
      }
      .sheet(isPresented: $showSettingView) { SettingsView() }
      .sheet(isPresented: $showLatestView) { LatestGamesView() }
      .confettiCannon(counter: $counter, num: 100, rainHeight: 3000, radius: 500)
      .onChange(of: vm.showWinScreen) { oldValue, newValue in
        guard newValue && vm.confettiEnabled else { return }
        counter += 1
      }
      .navigationTitle("HexCode")
      .navigationBarTitleDisplayMode(.inline)
    }
    .onReceive(timer) { _ in
 
      guard vm.timerEnabled, let currentTime = timerTime, !vm.gameEnded else { return }
      
      if currentTime > 0 {
        timerTime = currentTime - 1
      } else {
        timerTime = 0
        vm.gameLostActions()
        timer.upstream.connect().cancel()
      }
    }
    .onChange(of: vm.colorToGuess) {
      timer.upstream.connect().cancel()
      timerTime = vm.timerTime
    }
    .toolbar(content: toolbarContent)
    .overlay(content: overlayContent)
  }
}

extension ContentView {
  
  @ViewBuilder
  func overlayContent() -> some View {
    if vm.showWinScreen {
      Image(systemName: "checkmark")
        .endingScreenModifier(win: true)
    } else if vm.showLoseScreen {
      Image(systemName: "xmark")
        .endingScreenModifier(win: false)
    }
  }
  
  func toolbarContent() -> some ToolbarContent {
    Group {
      ToolbarItem(placement: .topBarTrailing) {
        Button {
          showSettingView.toggle()
          vm.playHaptic()
        } label: {
          Label("Settings", systemImage: "gear")
        }
        .tint(vm.selectedColorOption.color)
      }
      
      ToolbarItem(placement: .topBarLeading) {
        Button(action: {
          showLatestView.toggle()
          vm.playHaptic()
        }) {
          Label("Latest Games", systemImage: "list.bullet")
        }
        .tint(vm.selectedColorOption.color)
      }
    }
  }
  
  func submitButtonActions() {
    if vm.doStartTimer() { startTimer() }
    if vm.gameEnded { saveGame() }
    vm.submitButtonActions()
    focus = false
  }
  
  func startTimer() {
    timerTime = vm.timerTime
    timer = timer.upstream.autoconnect()
  }
  
  func saveGame() {
    let game = Game(colorToGuess: vm.colorToGuess, allGuesses: vm.allGuesses, length: vm.selectedNumberOfLetters.number)
    modelContext.insert(game)
    try? modelContext.save()
  }
}

#Preview {
  NavigationStack {
    ContentView()
      .environmentObject(ColoresViewModel.shared)
  }
}

