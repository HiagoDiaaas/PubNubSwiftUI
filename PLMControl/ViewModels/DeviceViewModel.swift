//
//  DeviceViewModel.swift
//  PLMControl
//
//  Created by Gregory Richardson on 9/22/22.
//

import SwiftUI


class DeviceViewModel: ObservableObject {
    @Published var plmDevice: [Device] = [] // published variable named people of type array initialize it empty
    
    init() {  // run the first message when class initializes fills data in the array
        addPeople()
    }
    
    func addPeople() {
        plmDevice = peopleData
        print("init func addPeople")
    }
    
    func shuffleOrder() {
        plmDevice.shuffle()
    }
    
    func reverseOrder() {
        plmDevice.reverse()
    }
    
    func removeLastPerson() {
        plmDevice.removeLast()
    }
    
    func removeFirstPerson() {
        plmDevice.removeFirst()
    }
}

let peopleData = [
    Device(name: "PLM 1", location: "clinic 1", status: "connect", state: "Enabled"),
    Device(name: "PLM 2", location: "clinic 1", status: "disconnected", state: "Disabled"),
    Device(name: "PLM Ultimate", location: "clinic 1", status: "connect", state: "Enabled"),
   // Device(name: "Daenarys Targaryen", status: "daenarys@email.com", state: "555-5555"),
   // Device(name: "Samwell Tarly", status: "samwell@email.com", state: "555-5555")
]
