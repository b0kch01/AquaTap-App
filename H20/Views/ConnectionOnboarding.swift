//
//  ConnectionOnboarding.swift
//  ConnectionOnboarding
//
//  Created by Nathan Choi on 9/27/21.
//

import SwiftUI

struct ConnectionOnboarding: View {

    @EnvironmentObject var blem: BLEManager
    @Environment(\.presentationMode) var modal

    var body2: some View {
        Form {
            Button("Start Scan") {
                blem.startScanning()
            }

            Button("Clean Scan") {
                blem.peripherals = []
            }


            Text("Bluetooth \(blem.bleOn ? "On" : "Off")")

            Section(header: Text("Devices")) {
                ForEach(blem.peripherals) { peripheral in
                    Button {
                        if blem.connectedPeripheral?.name == peripheral.name {
                            print("New Char:", blem.readCharacteristic?.value)
                        } else {
                            if let peripheralSafe = peripheral.peripheral {
                                blem.connect(peripheralSafe)
                            }
                        }
                    } label: {
                        HStack {
                            Text(peripheral.name)
                            Spacer()
                            Text(String(peripheral.rssi))
                        }
                    }
                    .foregroundColor(blem.connectedPeripheral?.name == peripheral.name ? .green : .primary)
                }
            }
        }
        .animation(.default)
    }

    var body: some View {
        VStack {
            Spacer()


            ZStack {
                CircleAnimation()

                Text("Connect your\nH20 Bottle")
                    .font(.system(size: 20, weight: .bold, design: .monospaced))
                    .multilineTextAlignment(.center)
            }
            .opacity(blem.peripherals.count < 1 ? 1 : 0)
            .frame(maxHeight: blem.peripherals.count < 1 ? .infinity : 0)
            .animation(.spring())

            ForEach(blem.peripherals) { peripheral in
                Button(action: {
                    blem.disconnect()
                    if blem.connectedPeripheral?.name == peripheral.name {
                        print("New Char:", blem.readCharacteristic?.value)
                    } else {
                        if let peripheralSafe = peripheral.peripheral {
                            blem.connect(peripheralSafe)
                        }
                    }
                }) {
                    HStack(spacing: 20) {
                        Text(peripheral.name)
                            .font(.system(size: 16, weight: .medium, design: .monospaced))
                            .foregroundColor(blem.connectedPeripheral?.name == peripheral.name ? .green : .primary)
                        Spacer()

                        Text(String(peripheral.rssi))
                            .font(.system(size: 12, weight: .light, design: .monospaced))
                            .foregroundColor(.secondary)
                    }
                    .padding(20)
                    .background(
                        Color(.secondarySystemBackground)

                    )
                    .padding(.horizontal, 20)
                }
            }
            .animation(.spring())

            Spacer()
        }
        .onAppear {
            blem.peripherals = []
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                blem.startScanning()
            }
        }
        .onChange(of: blem.connectedPeripheral) { p in
            modal.wrappedValue.dismiss()
        }
    }
}

struct ConnectionOnboarding_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionOnboarding()
    }
}
