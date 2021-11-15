//
//  BluetoothManager.swift
//  H20
//
//  Created by Nathan Choi on 7/28/21.
//

import Foundation
import CoreBluetooth

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {

    @Published var bleOn = false
    @Published var peripherals = [Peripheral]()
    @Published var data = [200.0, 0]

    @Published var connectedPeripheral: CBPeripheral?
    var centralManager: CBCentralManager!

    public var readCharacteristic: CBCharacteristic?
    private var writeCharacteristic: CBCharacteristic?
    private var notifyCharacteristic: CBCharacteristic?

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        bleOn = central.state == .poweredOn
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let uuid = peripheral.identifier
        if
            let name = advertisementData[CBAdvertisementDataLocalNameKey] as? String,
            !peripherals.contains(where: { $0.uuid == uuid })
        {
            let newPeripheral = Peripheral(
                id: peripherals.count,
                name: name,
                rssi: RSSI.intValue,
                uuid: uuid,
                peripheral: peripheral
            )
            peripherals.append(newPeripheral)
        }
    }

    func startScanning() {
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }

    func connect(_ peripheral: CBPeripheral) {
        guard let current = connectedPeripheral else {
            centralManager.connect(peripheral, options: nil)
            return
        }
        centralManager.cancelPeripheralConnection(current)
        centralManager.connect(peripheral, options: nil)
    }

    func send(_ value: String) {
        guard let characteristic = writeCharacteristic else { return }
        connectedPeripheral?.writeValue(value.data(using: .utf8)!, for: characteristic, type: .withResponse)
    }

    func disconnect() {
        guard let current = connectedPeripheral else { return }
        centralManager.cancelPeripheralConnection(current)
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) { print(error!) }
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        connectedPeripheral = nil
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        connectedPeripheral = peripheral
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        services.forEach {
            peripheral.discoverCharacteristics(nil, for: $0)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        let dataChar = characteristics.last
        peripheral.setNotifyValue(true, for: dataChar!)
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let value = characteristic.value else {
            return print("BLE Error: No value found!")
        }

        guard let stringValue = String(data: value, encoding: .utf8) else {
            return print("BLE Error: Data is not cannot be encoded into a string")
        }


        guard let doubleValue = Double(stringValue.trimmingCharacters(in: .whitespacesAndNewlines)) else {
            return print("Message:", stringValue)
        }

        print("Added new value:", doubleValue)
        data.append(doubleValue)
    }
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) { }
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) { }

    override init() {
        super.init()

        centralManager = CBCentralManager(delegate: self, queue: nil)
        centralManager.delegate = self
    }
}

struct Peripheral: Identifiable {
    let id: Int
    let name: String
    let rssi: Int
    let uuid: UUID
    let peripheral: CBPeripheral?

    init(id: Int, name: String, rssi: Int, uuid: UUID, peripheral: CBPeripheral) {
        self.id = id
        self.name = name
        self.rssi = rssi
        self.uuid = uuid
        self.peripheral = peripheral
    }

    init(name: String) {
        self.id = 0
        self.name = name
        self.rssi = 0
        self.uuid = UUID()
        self.peripheral = nil
    }
}
