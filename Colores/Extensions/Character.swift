//
//  Character.swift
//  Colores
//
//  Created by Santi Ochoa on 9/23/24.
//

extension Character {
  var hexNumber: Int {
    return Int(String(self), radix: 16) ?? 0
  }
}
