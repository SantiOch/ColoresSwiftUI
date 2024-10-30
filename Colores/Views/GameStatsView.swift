//
//  GameStatsView.swift
//  Colores
//
//  Created by Santi Ochoa on 9/25/24.
//

import SwiftUI
import SwiftData
import Charts

struct GameStatsView: View {
  
  @Query var allGames: [Game]
  
  var chartData: [ChartDataEntry] {
    
    var totales: [String: Int] = [:]
    
    for index in 1..<5 {
      totales[index.description, default: 0] = 0
    }
    
    totales[">5"] = 0
    
    for game in dummyData6 {
      if game.allGuesses.count < 5{
        totales[game.allGuesses.count.description, default: 0] += 1
      } else {
        totales[">5", default: 0] += 1
      }
    }
    
    return totales.map{ ChartDataEntry(value: $0.key, quantity: $0.value) }
      .sorted(by: { $0.value < $1.value })
  }
  
  @State var selectedBar: String?
  
  var body: some View {
    NavigationStack {
      ScrollView {
        
        Spacer()
          .frame(height: 100)
        
        chartSection()
        
        textSection()
      }
      .navigationBarTitle("Game Stats")
    }
  }
  
  @ViewBuilder
  private func chartSection() -> some View {
    
    let maxNumberOfTries = chartData.max(by: { $0.quantity < $1.quantity })?.quantity ?? 0
    
    Chart() {
      ForEach(chartData) { data in
        BarMark(x: .value("Count", data.value),
                y: .value("Quantity", data.quantity),
                width: 30)
        .foregroundStyle(by: .value("Value", data.id.uuidString))
        .cornerRadius(5)
      }
      
      if let selectedBar {
        RuleMark(x: .value("SelectedVar", selectedBar))
          .foregroundStyle(.gray.opacity(0.35))
          .zIndex(-1)
          .annotation(position: .top, spacing: 0, overflowResolution: .init(x: .fit, y: .disabled)) {
            chartAnnotation()
          }
      }
    }
    .chartYScale(domain: 0...maxNumberOfTries + 1)
    .chartXSelection(value: $selectedBar)
    .chartLegend(.hidden)
    .padding()
    .frame(width: 370, height: 350)
    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
    .padding(.top, 5)
    
  }
  
  @ViewBuilder
  private func chartAnnotation() -> some View {
    VStack {
      Text("Max tries")
      Text("Average tries")
    }
    .padding()
    .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
  }
  
  @ViewBuilder
  private func textSection() -> some View {
    let maxNumberOfTries = dummyData6.max(by: { $0.allGuesses.count < $1.allGuesses.count })?.allGuesses.count ?? 0
    let averageNumberOfTries = Double(dummyData6.reduce(0) { $0 + $1.allGuesses.count }) / Double(dummyData6.count)
    
    Text(maxNumberOfTries.description)
    Text(selectedBar ?? "None")
    Text(Int(round(averageNumberOfTries)).description)
  }
}

struct ChartDataEntry: Identifiable {
  var id = UUID()
  var value: String
  var quantity: Int
}


#Preview {
    GameStatsView()
  
}
