//
//  ArcFilledOutline.swift
//  Colores
//
//  Created by Santi Ochoa on 10/20/24.
//
import SwiftUI

struct ArcFilledOutline: Shape {
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
    path.addArc(
      center: center,
      radius: radius + lineWidth / 2,
      startAngle: startAngle,
      endAngle: endAngle,
      clockwise: false
    )
    
    let topRightCenter = CGPoint(x: center.x + radius * CGFloat(cos(endAngle.radians)), y: center.y + radius * CGFloat(sin(endAngle.radians)))
    let topLeftCenter = CGPoint(x: center.x + radius * CGFloat(cos(startAngle.radians)), y: center.y + radius * CGFloat(sin(startAngle.radians)))
    let bottomCenter = CGPoint(x: rect.midX, y: rect.maxY)
    let rightAngle = Angle(radians: atan2(topRightCenter.y - bottomCenter.y, topRightCenter.x - bottomCenter.x) + .pi / 2)
    let leftAngle = Angle(radians: atan2(bottomCenter.y - topLeftCenter.y, bottomCenter.x - topLeftCenter.x) + .pi / 2)
    
    path.addArc(
      center: topRightCenter,
      radius: lineWidth / 2,
      startAngle: endAngle,
      endAngle: rightAngle,
      clockwise: false
    )
    
    path.addArc(
      center: bottomCenter,
      radius: lineWidth / 2,
      startAngle: rightAngle,
      endAngle: leftAngle,
      clockwise: false
    )
    
    path.addArc(
      center: topLeftCenter,
      radius: lineWidth / 2,
      startAngle: leftAngle,
      endAngle: startAngle,
      clockwise: false
    )
    
            path.closeSubpath()
    
    return path
  }
}
