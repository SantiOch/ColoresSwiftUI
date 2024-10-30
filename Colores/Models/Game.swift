//
//  Guess.swift
//  Colores
//
//  Created by Santi Ochoa on 9/23/24.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class Game: Identifiable {
  
  var id: UUID = UUID()
  
  var colorToGuess: String
  var allGuesses: [String]
  var date: Date = Date()
  var length: Int
  
  init(colorToGuess: String, allGuesses: [String], length: Int) {
    self.colorToGuess = colorToGuess
    self.allGuesses = allGuesses
    self.length = length
  }
}

