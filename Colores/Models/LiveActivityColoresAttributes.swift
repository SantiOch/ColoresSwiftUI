//
//  LiveActivityColoresAttributes.swift
//  Colores
//
//  Created by Santi Ochoa on 10/15/24.
//
import SwiftUI
import ActivityKit

struct LiveActivityColoresAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
      var colorToGuess: String
      var latestGuess: String
      var guessCount: Int
    }
    
    // Fixed non-changing properties about your activity go here!
}
