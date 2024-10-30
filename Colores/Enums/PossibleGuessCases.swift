//
//  PossibleGuessCases.swift
//  Colores
//
//  Created by Santi Ochoa on 9/27/24.
//
import SwiftUI

enum PossibleGuessCases: String, CaseIterable {
  case correct
  case higherByLessThanThree
  case lowerByLessThanThree
  case higherByMoreThanThree
  case lowerByMoreThanThree
}
