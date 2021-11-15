//
//  CircleAnimation.swift
//  H20
//
//  Created by Nathan Choi on 10/11/21.
//

import SwiftUI

struct CircleAnimation: View {

    @State var animate = false

    var body: some View {
        Circle()
            .fill(Color(.secondarySystemBackground).opacity(0.5))
            .frame(width: animate ? 220 : 250, height: animate ? 220 : 250)
            .overlay(
                Circle()
                    .fill(.blue.opacity(0.03))
                    .frame(width: animate ? 280 : 300, height: animate ? 280 : 300)
            )
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 1).repeatForever()) {
                    animate = true
                }
            }
    }
}

struct CircleAnimation_Previews: PreviewProvider {
    static var previews: some View {
        CircleAnimation()
    }
}
