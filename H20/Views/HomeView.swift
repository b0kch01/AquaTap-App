//
//  HomeView.swift
//  HomeView
//
//  Created by Nathan Choi on 9/27/21.
//

import SwiftUI
import SwiftUICharts

struct HomeView: View {

    @EnvironmentObject var ble: BLEManager

    @State var showSettings = false
    @State var showConnectionScreen = false

    var overlay: some View {
        HStack(spacing: 20) {
            Button(action: { showConnectionScreen.toggle() }) {
                HStack {
                    Text("Status")
                        .foregroundColor(.primary)
                        .font(.headline)
                    Spacer()
                    Text(ble.connectedPeripheral != nil ? "Connected" : "Disconnected")
                        .foregroundColor(ble.connectedPeripheral != nil ? .green : .red)
                }
                .padding(.horizontal, 20)
                .frame(minHeight: 60)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.secondarySystemGroupedBackground)))
                .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
            }

            Button(action: { showSettings.toggle() }) {
                Image(systemName: "gear")
                    .font(.title)
                    .foregroundColor(.white)
                    .frame(minWidth: 60, minHeight: 60)
                    .background(RoundedRectangle(cornerRadius: 10).fill(.blue))
                    .shadow(color: .blue.opacity(0.5), radius: 10, y: 5)
            }
        }
        .padding(20)
    }

    var body: some View {
        ScrollView {
            HStack {
                VStack(alignment: .leading) {
                    Text("Bottle Stats")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("View battery level, water level, and more!")
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            .padding(20)

            GeometryReader { geo in
                LineView(data: ble.data)
                    .padding(20)
                    .frame(height: geo.size.height)
                    .allowsHitTesting(false)
            }


            VStack {
                Text(String(ble.data.last ?? -1))
                    .font(.system(size: 40, weight: .bold, design: .monospaced))
                Text("mm")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer().frame(height: 1000)

        }
        .overlay(overlay, alignment: .bottom)
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showConnectionScreen) {
            ConnectionOnboarding()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
