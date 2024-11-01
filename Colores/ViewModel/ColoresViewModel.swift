//
//  ColoresViewModel.swift
//  Colores
//
//  Created by Santi Ochoa on 9/22/24.
//

import SwiftUI
import Foundation
import SwiftData
import ConfettiSwiftUI
import ActivityKit

var dummyData6: [Game] {
  let number = 6
   return [
    .init(colorToGuess: randomHex(length: number), allGuesses: [
      randomHex(length: number), randomHex(length: number),
      randomHex(length: number), randomHex(length: number),
      randomHex(length: number), randomHex(length: number),
      randomHex(length: number), randomHex(length: number),
      randomHex(length: number),
    ], length: number),
    .init(colorToGuess: randomHex(length: number), allGuesses: [randomHex(length: number), randomHex(length: number),randomHex(length: number), randomHex(length: number),], length: number),
    .init(colorToGuess: randomHex(length: number), allGuesses: [randomHex(length: number), randomHex(length: number),randomHex(length: number), randomHex(length: number),randomHex(length: number)], length: number),
    .init(colorToGuess: randomHex(length: number), allGuesses: [randomHex(length: number), randomHex(length: number)], length: number),
  ]
}

func randomHex(length: Int) -> String {
  String((0..<length).map{ _ in hex.randomElement()!})
}

@MainActor class ColoresViewModel: ObservableObject {
  
  static let shared = ColoresViewModel()
    
  @AppStorage("selectedDarkMode") var selectedDarkMode: DarkModeOptions = .system {
    didSet {
      self.changeStyleHandler()
    }
  }
  
  @AppStorage("vibrationType") var selectedVibrationType: VibrationTypes = .medium {
    didSet {
      self.playHaptic()
    }
  }
  @AppStorage("selectedColor") var selectedColorOption: ColorOptions = .indigo
  @AppStorage("vibrationEnabled") var vibrationEnabled: Bool = true
  @AppStorage("confettiEnabled") var confettiEnabled: Bool = true
  @AppStorage("timerEnabled") var timerEnabled: Bool = false {
    didSet {
      self.resetActions()
    }
  }
  @AppStorage("timerTime") var timerTime: Double = 30 {
    didSet {
      self.resetActions()
    }
  }
  @AppStorage("numberOfLetters") var selectedNumberOfLetters: NumberOfLetters = .long {
    didSet {
      self.resetActions()
    }
  }
  @AppStorage("difficultyOption") var selectedDifficultyOption: DifficultyOptions = .easy {
    didSet {
      self.resetActions()
    }
  }
  @AppStorage("numberOfGuesses") var selectedNumberOfGuesses: NumberOfGuesses = .three {
    didSet {
      self.resetActions()
    }
  }
  
//  @Published var timer: Timer = .init()
  @Published var currentColorGuessed: String = "555555"
  @Published var currentGuess: String = ""
  @Published var showWinScreen: Bool = false
  @Published var showLoseScreen: Bool = false
  @Published var showPopover: Bool = false
  @Published var activityId: String?

  var gameEnded: Bool = false
  var gameLost: Bool = false

#if targetEnvironment(simulator)
  @Published var colorToGuess: String = "555555"
  @Published var allGuesses: [String] =  [
    randomHex(length: 6), randomHex(length: 6),
    randomHex(length: 6), randomHex(length: 6),
    randomHex(length: 6), randomHex(length: 6),
    randomHex(length: 6), randomHex(length: 6),
    randomHex(length: 6), randomHex(length: 6),
    randomHex(length: 6), randomHex(length: 6),
    randomHex(length: 6), randomHex(length: 6),
  ]
#else
  @Published var colorToGuess: String = randomHex(length: 6)
  @Published var allGuesses: [String] = []
#endif
  
  init() {
    self.changeStyleHandler()
    self.resetActions()
  }
  
  func submitButtonActions() {
    withAnimation {
      if gameEnded {
        resetActions()
      } else {
        if guessIsValid() {
          validGuessActions()
        } else {
          playErrorHaptic()
          showPopover = true
        }
      }
    }
  }
  
  func numberOfGuessesLeft() -> String {
    guard selectedNumberOfGuesses != .unlimited else { return "Unlimited number of" }
    let guessesLeft = selectedNumberOfGuesses.number - allGuesses.count
    
    return guessesLeft == 0 ? "No more" : "\(guessesLeft)"
  }

  func changeStyleHandler() {
    guard let window = UIApplication.shared.keyWindow else { return }
    
    let newInterfaceStyle: UIUserInterfaceStyle = selectedDarkMode.userInterface
    
    UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve) {
      window.overrideUserInterfaceStyle = newInterfaceStyle
    }
  }
  
  func playErrorHaptic() {
    guard vibrationEnabled else { return }
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(.error)
  }
  
  func demoHaptic(_ type: UIImpactFeedbackGenerator.FeedbackStyle) {
    let impactLight = UIImpactFeedbackGenerator(style: type)
    impactLight.impactOccurred()
  }
  
  func playHaptic() {
    guard vibrationEnabled else { return }
    let impactMed = UIImpactFeedbackGenerator(style: self.selectedVibrationType.feedback)
        impactMed.impactOccurred()
  }
}

extension ColoresViewModel {
  private func determineNumberCase(_ guess: Int, _ colorToGuess: Int) -> PossibleGuessCases {
    if guess == colorToGuess {
      return .correct
    }
    
    let difference = guess - colorToGuess
    
    if abs(difference) < 3 {
      return difference < 0 ? .higherByLessThanThree : .lowerByLessThanThree
    }
    else {
      return difference < 0 ? .higherByMoreThanThree : .lowerByMoreThanThree
    }
  }
  
  @ViewBuilder
  func getImage(for guess: Character,
                letterToGuess: Character,
                difficultyOption: DifficultyOptions? = nil) -> some View {
    
    let optionToSwitch = difficultyOption ?? selectedDifficultyOption
    
    switch optionToSwitch {
    case .easy:
      getEasyImage(for: guess, letterToGuess: letterToGuess)
    case .medium:
      getMediumImage(for: guess, letterToGuess: letterToGuess)
    case .hard:
      getHardImage(for: guess, letterToGuess: letterToGuess)
    }
  }
  
  @ViewBuilder
  private func getEasyImage(for guess: Character, letterToGuess: Character) -> some View {
    switch determineNumberCase(guess.hexNumber, letterToGuess.hexNumber) {
    case .correct:
      Image(systemName: "checkmark.circle.fill")
        .foregroundColor(.green)
    case .higherByLessThanThree:
        Image.doubleArrowUp
        .foregroundColor(selectedColorOption.color)
    case .lowerByLessThanThree:
        Image.doubleArrowDown
        .foregroundColor(selectedColorOption.color)
    case .higherByMoreThanThree:
      Image(systemName: "arrow.up")
        .foregroundColor(selectedColorOption.color)
    case .lowerByMoreThanThree:
      Image(systemName: "arrow.down")
        .foregroundColor(selectedColorOption.color)
    }
  }
  
  @ViewBuilder
  private func getMediumImage(for guess: Character, letterToGuess: Character) -> some View {
    switch determineNumberCase(guess.hexNumber, letterToGuess.hexNumber) {
    case .correct:
      Image(systemName: "checkmark.circle.fill")
        .foregroundColor(.green)
    case .higherByMoreThanThree, .higherByLessThanThree:
      Image(systemName: "arrow.up")
        .foregroundColor(selectedColorOption.color)
    case .lowerByLessThanThree, .lowerByMoreThanThree:
      Image(systemName: "arrow.down")
        .foregroundColor(selectedColorOption.color)
    }
  }
  
  @ViewBuilder
  private func getHardImage(for guess: Character, letterToGuess: Character) -> some View {
    switch determineNumberCase(guess.hexNumber, letterToGuess.hexNumber) {
    case .correct:
      Image(systemName: "checkmark.circle.fill")
        .foregroundColor(.green)
    default :
      Image(systemName: "xmark.circle.fill")
        .foregroundColor(selectedColorOption.color)
    }
  }
}

extension ColoresViewModel {
  
  private func validGuessActions() {
    currentColorGuessed = currentGuess
    allGuesses.append(currentGuess)
    if currentGuess == colorToGuess { winningActions() }
    if !canStillPlay() { gameLostActions() }
    currentGuess = ""
    Task { await updateActivity() }
  }
  
  func doStartTimer() -> Bool {
    !gameEnded && self.timerEnabled && allGuesses == [] && guessIsValid()
  }
  
  func gameLostActions() {
    playHaptic()
    gameLost = true
    gameEnded = true
    showLoseScreen = true
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
      withAnimation {
        showLoseScreen = false
      }
    }
  }
  
  private func canStillPlay() -> Bool {
    guard selectedNumberOfGuesses != .unlimited && !gameEnded else { return true }
    
    return selectedNumberOfGuesses.number > allGuesses.count
  }
  
  private func guessIsValid() -> Bool {
    currentGuess.compactMap({ char in
      hex.contains(char) ? char : nil
    }).count == selectedNumberOfLetters.number
  }
  
  private func resetActions() {
    gameLost = false
    gameEnded = false
    colorToGuess = randomHex(length: selectedNumberOfLetters.number)
    allGuesses.removeAll()
    currentColorGuessed = "555555"
    Task { await updateActivity() }
  }
  
  private func winningActions() {
    playHaptic()
    gameEnded = true
    showWinScreen = true
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
      withAnimation {
        showWinScreen = false
      }
    }
  }
  
  public func startNewLiveActivity() throws {
    
    guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
    
    let attributes = LiveActivityColoresAttributes()
    
    let initialContentState = ActivityContent(state: LiveActivityColoresAttributes.ContentState(colorToGuess: self.colorToGuess, latestGuess: self.allGuesses.last ?? Int.random(in: 100..<999).description, guessCount: self.allGuesses.count), staleDate: nil)
    
    do {
      let activity = try Activity.request(attributes: attributes, content: initialContentState)
      activityId = activity.id
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
      }
    } catch {
      throw error
    }
  }
  
  public func endLiveActivity() {
    
    Activity<LiveActivityColoresAttributes>.activities.forEach { activity in
      Task {
        await activity.end(nil, dismissalPolicy: .immediate)
      }
    }
    self.activityId = nil
  }
  
  public func updateActivity() async {
    
    guard let activity = Activity<LiveActivityColoresAttributes>.activities.first(where: {
      $0.id == self.activityId }) else { return }
    
    let contentState = LiveActivityColoresAttributes.ContentState(
      colorToGuess: self.colorToGuess,
      latestGuess: self.allGuesses.last ?? "555555",
      guessCount: self.allGuesses.count
      )
    
    let content = ActivityContent(state: contentState, staleDate: nil)
  
    await activity.update(content)
    }
}

//extension UIApplication {
//  var keyWindow: UIWindow? {
//    // Get connected scenes
//    return self.connectedScenes
//    // Keep only active scenes, onscreen and visible to the user
//      .filter { $0.activationState == .foregroundActive }
//    // Keep only the first `UIWindowScene`
//      .first(where: { $0 is UIWindowScene })
//    // Get its associated windows
//      .flatMap({ $0 as? UIWindowScene })?.windows
//    // Finally, keep only the key window
//      .first(where: \.isKeyWindow)
//  }
//}

#Preview {
  NavigationStack {
    SettingsView()
      .environmentObject(ColoresViewModel.shared)
  }
}
