//
//  SettingsView.swift
//  SettingsView
//
//  Created by Nathan Choi on 9/27/21.
//

import SwiftUI
import SwiftlySearch

struct SettingsView: View {

    @AppStorage("refresh-rate") var refreshRate = UD.get("refresh-rate", fallback: 1000 * 60 * 5)
    @State var searchText = ""

    @EnvironmentObject var blem: BLEManager

    @ViewBuilder
    var body: some View {
        let ratePicker = Binding<Int>(
            get: {
                if refreshRate <= 15 {
                    return 0
                }
                if refreshRate <= 30 {
                    return 1
                }
                return 2
            },
            set: { value in
                if value == 0 {
                    refreshRate = 15
                } else if value == 1 {
                    refreshRate = 30
                } else {
                    refreshRate = 60
                }
            }
        )

        NavigationView {
            Form {
                Section(header: Text("Bottle Measurement")) {
                    Stepper(value: $refreshRate, in: 5...60, step: 5) {
                        Text("**Records every** \(Int(refreshRate)) minute\(refreshRate == 1 ? "" : "s")")
                    }

                    Picker("Measurement Rate", selection: ratePicker) {
                        Text("Accurate").tag(0)
                        Text("Balanced").tag(1)
                        Text("Battery Saver").tag(2)
                    }
                    .pickerStyle(.segmented)
                    .padding(.vertical, 10)
                }

                Button("Clear data") {
                    blem.data = [130, 0]
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
