//
//  SettingsView.swift
//  Colores
//
//  Created by Santi Ochoa on 9/25/24.
//

import SwiftUI

struct SettingsView: View {
  
  @EnvironmentObject var vm: ColoresViewModel
  @Environment(\.dismiss) var dismiss
  
  @State private var showDifficultyHelp: Bool = false
  
  var body: some View {
    NavigationStack {
      Form {
        
        appearanceSection()
        
        vibrationSection()
        
        miscellaneousSection()
        
        confettiSection()
        
        gameSettingsSection()
        
      }
      .sheet(isPresented: $showDifficultyHelp) {
        NavigationStack {
          DifficultyHelpView()
        }
      }
        .navigationTitle("Settings")
        .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) {
            Button("Done") { dismiss() }
              .bold()
              .tint(vm.selectedColorOption.color)
          }
        }
    }
    .tint(vm.selectedColorOption.color)
  }
}

extension SettingsView {
  
  @ViewBuilder
  func miscellaneousSection() -> Section<some View, some View, some View> {
    Section {
      miscellaneousSectionContent()
    } header: {
      Text("Accent color")
    } footer: {
      Text("Change the app's accent color, this will change button colors, navigation bar colors, launch a live activity and more.")
    }
  }
  
  @ViewBuilder
  func miscellaneousSectionContent() -> some View {
    
    let color = vm.selectedColorOption.color
    let label = vm.selectedColorOption.rawValue.capitalized
    
    MenuWithPicker(text: "Select app's accent color", label, color: color) {
      Picker("", selection: $vm.selectedColorOption) {
        ForEach(ColorOptions.allCases) { option in
          Label(
            title: { Text(option.title) },
            icon: { CircledImage(color: option.color) }
          )
          .tag(option)
        }
      }
    }
        
    Button {
      if let _ = vm.activityId {
        vm.endLiveActivity()
      } else {
        do {
          print("Starting new live activity...")
          try vm.startNewLiveActivity()
        } catch {
          print("Error starting new live activity: \(error)")
        }
      }
    } label: {
      HStack {
        Text((vm.activityId == nil) ? "Start live activity" : "Stop live activity")
        Spacer()
        Image(systemName: "bell")
          .symbolVariant(vm.activityId == nil ? .fill : .slash)
      }
    }
  }
}

extension SettingsView {
  
  @ViewBuilder
  func appearanceSection() -> Section<some View, some View, some View> {
    Section {
      appearanceSectionContent()
    } header: {
      Text("Appearance")
    } footer: {
      Text("Select a theme for the app")
    }
  }
  
  @ViewBuilder
  func appearanceSectionContent() -> some View {
    let color = vm.selectedColorOption.color
    let label = vm.selectedDarkMode.rawValue.capitalized
    
    MenuWithPicker(text: "Select theme for the app", label, color: color) {
      Picker("", selection: $vm.selectedDarkMode) {
        ForEach(DarkModeOptions.allCases) { option in
          Label(option.rawValue.capitalized, systemImage: option.systemImage)
            .tag(option)
        }
      }
    }
  }
}

extension SettingsView {
  
  @ViewBuilder
  func vibrationSection() -> Section<some View, some View, some View> {
    Section {
      vibrationSectionContent()
    } header: {
      Text("Vibration")
    } footer: {
      Text("Enable or disable the app's vibration and choose the type of vibration to use.")
    }
  }
  
  @ViewBuilder
  func vibrationSectionContent() -> some View {
    
    let color = vm.selectedColorOption.color
    let label = vm.selectedVibrationType.rawValue.capitalized
    
    Toggle("Enable vibration", isOn: $vm.vibrationEnabled)
    MenuWithPicker(text: "Select vibration type", label, color: color, disabled: !vm.vibrationEnabled) {
      Picker("", selection: $vm.selectedVibrationType) {
        ForEach(VibrationTypes.allCases) { option in
          Label(option.rawValue.capitalized, systemImage: option.systemImage)
            .tag(option)
        }
      }
    }
  }
}

extension SettingsView {
  
  @ViewBuilder
  func confettiSection() -> Section<some View, some View, some View> {
    Section {
      confettiSectionContent()
    } header: {
      Text("Visual effects")
    } footer: {
      Text("Enable or disable the app's visual effects.")
    }
  }
  
  @ViewBuilder
  func confettiSectionContent() -> some View {
    Toggle("Enable confetti", isOn: $vm.confettiEnabled)
  }
}

extension SettingsView {
  
  @ViewBuilder
  func gameSettingsSection() -> Section<some View, some View, some View> {
    Section {
      gameSettingsSectionContent()
    } header: {
      Text("Game settings")
    } footer: {
      Text("Change the settings for the game, such as the difficulty level, number of letters of the hex code, number of guesses or enabling or disabling the timer. Whenever the number of letters or the difficulty level changes, the game will reset.")
    }
  }
  
  @ViewBuilder
  func gameSettingsSectionContent() -> some View {
    
    let difficultyLabel = vm.selectedDifficultyOption.rawValue.capitalized
    let numberOfLetersLabel = vm.selectedNumberOfLetters.rawValue.capitalized
    let numberOfGuessesLabel = vm.selectedNumberOfGuesses.title
    let color = vm.selectedColorOption.color
    
    MenuWithPicker(text: "Select difficulty level", difficultyLabel,  color: color) {
      Picker("Difficulty level", selection: $vm.selectedDifficultyOption) {
        ForEach(DifficultyOptions.allCases) { difficultyLevel in
          Label(difficultyLevel.rawValue.capitalized, systemImage: difficultyLevel.systemImage)
            .tag(difficultyLevel)
        }
      }
    }
    
    MenuWithPicker(text: "Select number of letters", numberOfLetersLabel, color: color) {
      Picker("", selection: $vm.selectedNumberOfLetters) {
        ForEach(NumberOfLetters.allCases) { numberOfLetters in
          Label(numberOfLetters.rawValue.capitalized, systemImage: numberOfLetters.systemImage)
            .tag(numberOfLetters)
        }
      }
    }
    
    MenuWithPicker(text: "Select the number of guesses", numberOfGuessesLabel, color: color) {
      Picker("Select the number of guesses", selection: $vm.selectedNumberOfGuesses) {
        ForEach(NumberOfGuesses.allCases.reversed()) { numberOfGuesses in
          Text(numberOfGuesses.title)
            .tag(numberOfGuesses)
        }
      }
    }
    
    // Toggle y picker
    Toggle("Enable timer", isOn: $vm.timerEnabled)
    HStack {
      Text("Timer: \(Int(vm.timerTime))s")
        .frame(width: 100, alignment: .leading)
      Slider(value: $vm.timerTime, in: 10...60, step: 5)
        .tint(vm.selectedColorOption.color ?? .blue)
    }
    .disabled(!vm.timerEnabled)
      
    Button {
      showDifficultyHelp.toggle()
    } label: {
      HStack {
        Text("Show difficulty help")
        Spacer()
        Image(systemName: "questionmark.circle")
      }
    }
    
  }
}

struct MenuWithPicker<Content>: View where Content: View {
  
  var text: String
  var color: Color?
  var disabled: Bool = false
  var label: () -> Text
  var content: () -> Content
  
  init(text: String, color: Color? , disabled: Bool = false, label: @escaping () -> Text, content: @escaping () -> Content) {
    self.text = text
    self.color = color
    self.disabled = disabled
    self.label = label
    self.content = content
  }
  
  init (text: String, _ label: String, color: Color? , disabled: Bool = false, content: @escaping () -> Content) {
    self.text = text
    self.color = color
    self.disabled = disabled
    self.label = { Text(label) }
    self.content = content
  }
  
  var body: some View{
    HStack {
      Text(text)
      Spacer()
      Menu(content: content) {
        pickerLabel(text: label, color: color)
      }
    }
    .disabled(disabled)
  }
  
  @ViewBuilder
  func pickerLabel(text: @escaping () -> Text, color: Color? ) -> some View {
    HStack(spacing: 5) {
      text()
        .tint(.secondary)
      Image(systemName: "chevron.up.chevron.down")
        .imageScale(.small)
    }
    .foregroundStyle(disabled ? (color ?? .secondary).opacity(0.5) : color ?? .secondary)
  }
}

#Preview {
  SettingsView()
    .environmentObject(ColoresViewModel())
}
