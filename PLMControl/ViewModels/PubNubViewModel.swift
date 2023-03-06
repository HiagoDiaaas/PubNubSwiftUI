//
//  PubNubViewModel.swift
//  PLMControl
//
//  Created by Gregory Richardson on 9/24/22.
//

import SwiftUI
import PubNub


class PubNubViewModel: ObservableObject {
    @Published var messages: [Message] = []
    var pubnub: PubNub
    let channel: String = "the_guide"
    let clientUUID: String = "ReplaceWithYourClientIdentifier"
    
    init() {
        
        var pnconfig = PubNubConfiguration(publishKey: "pub-c-0d0e8029-8a09-41b6-8a10-36d86d8b30b4", subscribeKey: "sub-c-95959627-7e95-46e1-a0ab-ae8eff908bba")
        
        pnconfig.uuid = clientUUID
        
        self.pubnub = PubNub(configuration: pnconfig)
        //initializes fills data in the array
 
        startListening()
        subscribe(to: self.channel)
      }
      
      lazy var listener: SubscriptionListener? = {
        let listener = SubscriptionListener()
        
        listener.didReceiveMessage = { [weak self] event in
          if let entry = try? event.payload.codableValue.decode(EntryUpdate.self) {
            
            self?.display(
              Message(messageType: "[MESSAGE: received]", messageText: "entry: \(entry.entry), update: \(entry.update)")
            )
              print("⚡️","listener.didReceiveMessage")
          }
        }
        
        listener.didReceivePresence = { [weak self] event in
          let userChannelDescription = "event uuid: \(event.metadata?.codableValue["pn_uuid"] ?? "null"), channel: \(event.channel)"
          
          self?.display(
            Message(messageType: "[PRESENCE: \(event.metadata?.codableValue["pn_action"] ?? "null")]", messageText: userChannelDescription)
          )
        }
        
        listener.didReceiveSubscriptionChange = { [weak self] event in
          switch event {
          case .subscribed(let channels, _):
            self?.display(Message(messageType: "[SUBSCRIPTION CHANGED: new channels]", messageText: "channels added: \(channels[0].id)"))
            self?.publish(update: EntryUpdate(update: "Did receive change on simulator"))
          default: break
          }
        }
        
        listener.didReceiveStatus = { [weak self] event in
          switch event {
          case .success(let connection):
            self?.display(Message(messageType: "[STATUS: connection]", messageText: "state: \(connection)"))
          case .failure(let error):
            print("Status Error: \(error.localizedDescription)")
          }
        }
        
        return listener
      }()
      
      func startListening() {
        if let listener = listener {
          pubnub.add(listener)
        }
      }
      
      func subscribe(to channel: String) {
        pubnub.subscribe(to: [channel], withPresence: true)
          
          print("⚠️","PLM: init func subscribe to channel named: \(channel)")
      }
      
      func display(_ message: Message) {
          if self.messages.count >= 4 {
              self.messages.removeFirst()
              print("📱👁","PLM: func display removeFirst message.count > \(messages.count)")
              self.messages.append(message)
              Logger.log(.warning, "PLM: func display .append message \(messages.count)")
          } else {
              self.messages.append(message)
              //print("PLM: func display .append message \(messages.count)")
              Logger.log(.action, "PLM: func display .append message \(messages.count)")
              
          }
          //print("PLM: func display message.count \(messages.count) named: \(message)")
          Logger.log(.error, "PLM: func display message.count \(messages.count) named: \(message)")
  
      }
      
      func publish(update entryUpdate: EntryUpdate) {
        pubnub.publish(channel: self.channel, message: entryUpdate) { [weak self] result in
          switch result {
          case let .success(timetoken):
            self?.display(
              Message(messageType: "[PUBLISH: sent]", messageText: "timetoken: \(timetoken.formattedDescription) (\(timetoken.description))"))
              print("PLM: func publish channel: \(self?.channel ?? "Empty")  struct entryUpdate: \(entryUpdate)")
          case let .failure(error):
            print("failed: \(error.localizedDescription)")
              Logger.log(.error, "failed: \(error.localizedDescription)")
          }
        }
      }
}

// MARK:- Extension Helpers
extension DateFormatter {
  static let defaultTimetoken: DateFormatter = {
    var formatter = DateFormatter()
    formatter.timeStyle = .medium
    formatter.dateStyle = .short
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
  }()
}

extension Timetoken {
  var formattedDescription: String {
    return DateFormatter.defaultTimetoken.string(from: timetokenDate)
  }
}

enum LogType: String{
case error
case warning
case success
case action
case canceled
}


class Logger{

 static func log(_ logType:LogType,_ message:String){
        switch logType {
        case LogType.error:
            print("📕 Error: \(message)")
        case LogType.warning:
            print("📙 Warning: \(message)")
        case LogType.success:
            print("📗 Success: \(message)")
        case LogType.action:
            print("📘 Action: \(message)")
        case LogType.canceled:
            print("📓 Cancelled: \(message)")
            //print("\n📓 Cancelled: \(message)\n") \n Returns a line
        }
    }

}

//2021-05-09T16:13:30-0500 🐛 debug thingsAboveAdmin : Testing log levels..
//2021-05-09T16:13:30-0500 ℹ️ info thingsAboveAdmin : Testing log levels..
//2021-05-09T16:13:30-0500 📖 notice thingsAboveAdmin : Testing log levels..
//2021-05-09T16:13:30-0500 ⚠️ warning thingsAboveAdmin : Testing log levels..
//2021-05-09T16:13:30-0500 ⚡ error thingsAboveAdmin : Testing log levels..
//2021-05-09T16:13:30-0500 🔥 critical thingsAboveAdmin : Testing log levels..
//
//2021-05-09T16:17:07-0500 🟪 debug thingsAboveAdmin : Testing log levels..
//2021-05-09T16:17:07-0500 🟦 info thingsAboveAdmin : Testing log levels..
//2021-05-09T16:17:07-0500 🟩 notice thingsAboveAdmin : Testing log levels..
//2021-05-09T16:17:07-0500 🟨 warning thingsAboveAdmin : Testing log levels..
//2021-05-09T16:17:07-0500 🟧 error thingsAboveAdmin : Testing log levels..
//2021-05-09T16:17:07-0500 🟥 critical thingsAboveAdmin : Testing log levels..
