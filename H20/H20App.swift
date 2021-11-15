//
//  H20App.swift
//  H20
//
//  Created by Nathan Choi on 7/28/21.
//

import SwiftUI

@main
struct H20App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(BLEManager())
        }
    }
}
