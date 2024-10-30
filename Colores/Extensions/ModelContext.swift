//
//  ModelContext.swift
//  Colores
//
//  Created by Santi Ochoa on 9/26/24.
//
import SwiftUI
import SwiftData

extension ModelContext {
  func deleteAll<T: PersistentModel>(_ arrayToDelete: [T]) {
    withAnimation {
      arrayToDelete.forEach { self.delete($0) }
    }
  }
}
