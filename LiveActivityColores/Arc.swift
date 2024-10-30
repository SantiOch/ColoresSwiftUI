//
//  Arc.swift
//  Colores
//
//  Created by Santi Ochoa on 10/20/24.
//
import SwiftUI

struct Arc: Shape {
  /// Percent
  ///
  /// How much of the Arc should we draw? `1` means 100%. `0.5` means half. Etc.
  let percent: CGFloat
  
  /// Line width
  ///
  /// How wide is the line going to be stroked. This is used to offset the arc within the `CGRect`.
  let lineWidth: CGFloat
  
  init(percent: CGFloat = 1, lineWidth: CGFloat = 1) {
    self.percent = percent
    self.lineWidth = lineWidth
  }
  
  func path(in rect: CGRect) -> Path {
    let rect = rect.insetBy(dx: lineWidth / 2, dy: lineWidth / 2)
    var path = Path()
    
    let x = rect.width / 2
    let y = rect.height
    let w = sqrt(x * x + y * y)
    let phi = atan2(x, y)
    
    let radius = w / 2 / cos(phi)
    let center = CGPoint(x: rect.minX + x, y: rect.minY + radius)
    
    let theta = 2 * (.pi / 2 - phi) * percent
    
    let startAngle = Angle(radians: 3 * .pi / 2 - theta)
    let endAngle = Angle(radians: 3 * .pi / 2 + theta)
    
    path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
    
    return path
  }
  
}
