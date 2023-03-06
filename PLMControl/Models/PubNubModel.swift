//
//  PubNubModel.swift
//  PLMControl
//
//  Created by Gregory Richardson on 9/24/22.
//

import PubNub
import SwiftUI


struct EntryUpdate: JSONCodable {
  var update: String
  var entry: String
  
  init(update: String,
       entry: String = "Default") {
    self.update = update
    self.entry = entry
  }
}

struct Message: Identifiable {
  var id = UUID()
  var messageType: String
  var messageText: String
}
