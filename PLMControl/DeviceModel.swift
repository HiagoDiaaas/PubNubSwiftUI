//
//  DeviceModel.swift
//  PLMControl
//
//  Created by Gregory Richardson on 9/22/22.
//

import Foundation

import SwiftUI

struct Device: Identifiable {
    var id = UUID()
    var name: String
    var location: String
    var status: String
    var state: String
}
