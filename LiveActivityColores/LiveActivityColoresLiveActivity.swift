//
//  LiveActivityColoresLiveActivity.swift
//  LiveActivityColores
//
//  Created by Santi Ochoa on 10/15/24.
//

import ActivityKit
import WidgetKit
import SwiftUI
import AppIntents

@main
struct LiveActivityColoresLiveActivity: Widget {
  
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: LiveActivityColoresAttributes.self) { context in
      // Lock screen/banner UI goes here
      HStack (spacing: 20){
        VStack {
          HexColoredSquare(hexColor: context.state.colorToGuess, sideSize: 100, cornerRadius: 15)
          Text("Color to guess")
            .font(.caption)
            .bold()
        }
        
        VStack (spacing: 5) {
          let textSize : CGFloat = 14
          
          Text("Latest Guess:")
            .font(.system(size: textSize))
            .bold()
          
          Text("#\(context.state.latestGuess.uppercased())")
            .font(.system(size: textSize))
            .bold()
          
          Text("Guess number:")
            .font(.system(size: textSize))
            .bold()
          
          Text("\(context.state.guessCount)")
            .font(.system(size: textSize))
            .bold()
        }
        
        VStack {
          HexColoredSquare(hexColor: context.state.latestGuess, sideSize: 100, cornerRadius: 15)
          Text("Latest Guess")
            .font(.caption)
            .bold()
        }
      }      //      .containerRelativeFrame(.vertical, alignment: .center)
      .padding(5)
//      .activityBackgroundTint()
//      .activitySystemActionForegroundColor(.white)
    } dynamicIsland: { context in
      DynamicIsland {
        DynamicIslandExpandedRegion (.leading) {
          VStack {
            HexColoredSquare(hexColor: context.state.colorToGuess, sideSize: 100, cornerRadius: 20)
            Text("Color to guess")
              .font(.caption)
              .bold()
          }
        }
        
        DynamicIslandExpandedRegion (.trailing) {
          VStack {
            HexColoredSquare(hexColor: context.state.latestGuess, sideSize: 100, cornerRadius: 20)
            Text("Latest Guess")
              .font(.caption)
              .bold()
          }
        }
        
        DynamicIslandExpandedRegion (.center) {
          VStack (spacing: 5) {
            
            let textSize : CGFloat = 14
            
            Text("Latest Guess:")
              .font(.system(size: textSize))
              .foregroundStyle(.white)
              .bold()
            
            Text("#\(context.state.latestGuess.uppercased())")
              .font(.system(size: textSize))
              .foregroundStyle(.white)
              .bold()
            
            Text("Guess number:")
              .font(.system(size: textSize))
              .foregroundStyle(.white)
              .bold()
            
            Text("\(context.state.guessCount)")
              .font(.system(size: textSize))
              .foregroundStyle(.white)
              .bold()
          }
        }
      } compactLeading: {
        HexColoredSquare(hexColor: context.state.colorToGuess, sideSize: 20, cornerRadius: 2, padding: 1, bottomPadding: true, backgroundColor: .white)
          .padding(2)
        
      } compactTrailing: {
        VStack (alignment: .trailing, spacing: 0){
          Text("COUNT")
            .font(.system(size: 10, weight: .semibold))
            .foregroundStyle(.cyan)
          
          Text("\(context.state.guessCount)")
            .bold()
        }
        .padding(.init(top: 2, leading: 0, bottom: 0, trailing: 5))
      } minimal: {
        HexColoredSquare(hexColor: context.state.colorToGuess, sideSize: 20, cornerRadius: 2, padding: 1, bottomPadding: true, backgroundColor: .white)
          .padding(2)
      }
    }
  }
}

extension LiveActivityColoresAttributes {
  fileprivate static var preview: LiveActivityColoresAttributes {
    LiveActivityColoresAttributes()
  }
}

extension LiveActivityColoresAttributes.ContentState {
  fileprivate static var smiley: LiveActivityColoresAttributes.ContentState {
    LiveActivityColoresAttributes.ContentState(colorToGuess: "555555", latestGuess: "1f2f3f", guessCount: 5)
  }
}

//
//
#Preview("Notification", as: .content, using: LiveActivityColoresAttributes.preview) {
  LiveActivityColoresLiveActivity()
} contentStates: {
  LiveActivityColoresAttributes.ContentState.smiley
}

#Preview("Expanded", as: .dynamicIsland(.expanded), using: LiveActivityColoresAttributes.preview) {
  LiveActivityColoresLiveActivity()
} contentStates: {
  LiveActivityColoresAttributes.ContentState.smiley
}
//
#Preview("Compact", as: .dynamicIsland(.compact), using: LiveActivityColoresAttributes.preview) {
  LiveActivityColoresLiveActivity()
} contentStates: {
  LiveActivityColoresAttributes.ContentState.smiley
}

#Preview("Minimal", as: .dynamicIsland(.minimal), using: LiveActivityColoresAttributes.preview) {
  LiveActivityColoresLiveActivity()
} contentStates: {
  LiveActivityColoresAttributes.ContentState.smiley
}

struct HexColoredSquare: View {
    
  var hexColor: String
  var sideSize: CGFloat = 150
  var cornerRadius: CGFloat = 10
  var padding: CGFloat = 5
  var bottomPadding: Bool = false
  var backgroundColor: Color = .clear
  
  var body: some View {
    RoundedRectangle(cornerRadius: cornerRadius)
      .fill(Color(hex: hexColor))
      .frame(width: sideSize, height: sideSize)
      .padding(.init(top: padding, leading: padding, bottom: bottomPadding ? padding : 0, trailing: padding))
      .background(backgroundColor)
      .clipShape(RoundedRectangle(cornerRadius: cornerRadius + padding))
  }
}

struct ExtractedView: View {
  
  let geometry: GeometryProxy
  let dynamicIsland: Bool
  
  var body: some View {
    HStack (alignment: .bottom) {
      Spacer()
      ZStack {
        Arc(lineWidth: 20)
          .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
          .foregroundStyle(.blue.secondary)
        
        ArcFilledOutline(percent: 0.35, lineWidth: 20)
          .foregroundStyle(.linearGradient(colors: [.blue, .cyan],
                                           startPoint: .bottom,
                                           endPoint: .top).opacity(0.5))
        
        Arc(percent: 0.35, lineWidth: 20)
          .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
          .foregroundStyle(.cyan)
        
        VStack {
          
          Image("satelite")
            .resizable()
            .scaledToFit()
            .frame(width: 30, height: 30)
            .colorInvert()
            .opacity(0.8)
            .rotationEffect(.degrees(315))
          
          Image(systemName: "circle.fill")
            .resizable()
            .foregroundStyle(.white)
            .frame(width: 12, height: 12)
            .opacity(0.8)
        }
        .rotationEffect(.degrees(320))
        .offset(x: -100, y: dynamicIsland ? -21 : -25)
        
      }
      .frame(width: geometry.size.width / 1.1,
             height: geometry.size.width / 5.5, alignment: .center)
      Spacer()
    }
    .padding(.top)
  }
}

//DynamicIsland {
//  DynamicIslandExpandedRegion(.bottom) {
//    GeometryReader { geometry in
//      ExtractedView(geometry: geometry, dynamicIsland: true)
//    }
//    .frame(height: 300)
//  }
//} compactLeading: {
//  Image(systemName: "umbrella.fill")
//    .foregroundStyle(.cyan)
//} compactTrailing: {
//  VStack (alignment: .trailing, spacing: 0){
//    Text("STARTS")
//      .font(.system(size: 10, weight: .semibold))
//      .foregroundStyle(.cyan)
//    
//    Text("1m")
//      .bold()
//  }
//  .padding(.init(top: 2, leading: 0, bottom: 0, trailing: 7))
//} minimal: {
//  Image(systemName: "umbrella.fill")
//    .foregroundStyle(.cyan)
//}
