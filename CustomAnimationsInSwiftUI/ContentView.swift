//
//  ContentView.swift
//  CustomAnimationsInSwiftUI
//
//  Created by Anu Mittal on 23/02/21.
//

import SwiftUI

// MARK: - Building custom transitions using ViewModifier
struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint

    func body(content: Content) -> some View {
        content.rotationEffect(.degrees(amount), anchor: anchor).clipped()
    }
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(
            active: CornerRotateModifier(amount: -90, anchor: .topLeading),
            identity: CornerRotateModifier(amount: 0, anchor: .topLeading)
        )
    }
}

// MARK:- Content View
struct ContentView: View {
  @State private var enabled = false
  @State private var dragAmount = CGSize.zero
  
  @State private var isShowingRed = false
  
  var body: some View {
    VStack {
      
      // MARK: - Controlling the animation stack
      Button("Tap Me") {
        self.enabled.toggle()
        withAnimation {
          self.isShowingRed.toggle()
        }
      }
      .frame(width: 200, height: 200)
      .background(enabled ? Color.blue: .red)
      .animation(.default) // can set .animations(nil) to remove any animation uptil this modifier
      .foregroundColor(.white)
      .clipShape(RoundedRectangle(cornerRadius: enabled ? 60 : 0))
      .animation(.interpolatingSpring(stiffness: 10, damping: 1))
      
      // MARK: - Animating gestures
      LinearGradient(
        gradient: Gradient(colors: [.yellow, .red]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing)
        .frame(width: 300, height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .offset(dragAmount)
        .gesture(
          DragGesture()
            .onChanged { self.dragAmount = $0.translation }
            .onEnded { _ in
              withAnimation(.spring()) {
                self.dragAmount = .zero
              }
            }
        )
      
      // MARK: - Showing and hiding views with transitions
      if isShowingRed {
        Rectangle()
          .fill(Color.red)
          .frame(width: 200, height: 200)
//          .transition(.scale)
          .transition(.asymmetric(insertion: .scale, removal: .opacity))
//          .transition(.pivot)
      }
    }
  }
}


// MARK:- ContentView_Previews
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
