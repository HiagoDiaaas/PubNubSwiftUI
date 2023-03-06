//
//  ContentView.swift
//  PLMControl
//
//  Created by Gregory Richardson on 9/22/22.
//

import SwiftUI

    // MARK:- View Stores
struct DevicesView: View {
    @ObservedObject var observedViewModel = DeviceViewModel() // the DeviceViewModel object is observable and the viewModel that is observing it (at) @ ObservedObject
    @State var isPrivate: Bool = true
    @State var notificationsEnabled: Bool = false
    @State private var previewIndex = 0
    @State var username: String = ""
    var previewOptions = ["Always", "When Unlocked", "Never"]
    @ObservedObject var pubnubStore = PubNubViewModel()
    @State var entry = "Test Text."
    @State  var enableLogging = false
    @State  var selectedColor = "Red"
    @State  var colors = ["Red", "Green", "Blue"]
    
    var body: some View {
        NavigationView {
            
            VStack(spacing: 0)  {
                Image(systemName: "car.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.blue)
                    .frame(width: 10, height: 50)
                    .frame(maxWidth: .infinity) /// make image centered
                    .listRowBackground(Color(.secondarySystemBackground)) /// match the List's background color
                Form {
                    Section(header: Text("PROFILE")) {
                        ForEach(observedViewModel.plmDevice.reversed()) { returned_device in
                        HStack {
                            Image("plm_icon").frame(width: 30, height: 10, alignment: .trailing)
                            Spacer().frame(width: 10, height: 50, alignment: .trailing)
                            VStack(alignment: .leading) {
                                Text(returned_device.name)
                                    .font(.title)
                                    .fontWeight(.bold)
                                Text(returned_device.location)
                                Spacer ()
                            } // VStack
                            Spacer ()
                            VStack(alignment: .trailing) {
                                Text(returned_device.state)
                                Text(returned_device.status)
                            } // VStack
                        } // HStack
                        .frame(height: 40)
                        .padding(10)
                    }
                    }
                    Section(header: Text("PROFILE")) {
                        
                        Toggle(isOn: $isPrivate) {
                            Text("Disable Account")
                        }
                    }
                }
                .navigationBarTitle("PLM Control Center", displayMode: .inline)
                .navigationBarItems(trailing: Button("NEXT") {
   
                })
                
                List {
                    Section(header: Text("Live Data Monitor")) {
                    /*
                    Button(action: {
                        pubnubStore.messages = []
                    }) {
                        Text("delete all data")
                    }
                    Button(action: submitUpdate) {
                      Text("CleanUp")
                        .padding()
                        .foregroundColor(Color.white)
                        .background(entry.isEmpty ? Color.secondary : Color.red)
                        .cornerRadius(40)
                    }
                    */
                   
                  ForEach(pubnubStore.messages.reversed()) { message in
                    VStack(alignment: .leading) {
                        //Text("bbb \(pubnubStore.messages.count)")
                      Text(message.messageType)
                      Text(message.messageText)
                        
                        /*
                        if message == pubnubStore.messages.last {
                                        pubnubStore.messages = []
                                    }
                        */
                        
                    } // VStack
                  }
               
                } // List
                }
            }
        } // NavigationView
            
            
            /*
            List {
                Button(action: {
                    pubnubStore.messages = []
                }) {
                    Text("delete all data")
                }
                Button(action: submitUpdate) {
                  Text("CleanUp")
                    .padding()
                    .foregroundColor(Color.white)
                    .background(entry.isEmpty ? Color.secondary : Color.red)
                    .cornerRadius(40)
                }
               
              ForEach(pubnubStore.messages.reversed()) { message in
                VStack(alignment: .leading) {
                    Text("bbb \(pubnubStore.messages.count)")
                  Text(message.messageType)
                  Text(message.messageText)
                    
                    /*
                    if message == pubnubStore.messages.last {
                                    pubnubStore.messages = []
                                }
                    */
                    
                } // VStack
              }
           
            } // List
            */
            /*
            List {
                Section { /// separate the image from the rest of the List's contents
                    Image(systemName: "car.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.blue)
                        .frame(width: 10, height: 10)
                        .frame(maxWidth: .infinity) /// make image centered
                        .listRowBackground(Color(.secondarySystemBackground)) /// match the List's background color
                
                    ForEach(observedViewModel.plmDevice.reversed()) { returned_device in
                        HStack {
                            Image("plm_icon").frame(width: 30, height: 10, alignment: .trailing)
                            Spacer().frame(width: 10, height: 50, alignment: .trailing)
                            VStack(alignment: .leading) {
                                Text(returned_device.name)
                                    .font(.title)
                                    .fontWeight(.bold)
                                Text(returned_device.location)
                                Spacer ()
                            } // VStack
                            Spacer ()
                            VStack(alignment: .trailing) {
                                Text(returned_device.state)
                                Text(returned_device.status)
                            } // VStack
                        } // HStack
                        .frame(height: 40)
                        .padding(10)
                    }
                } // List
                TextField("", text: $entry, onCommit: submitUpdate)
                  .textFieldStyle(RoundedBorderTextFieldStyle())
                  .frame(width: 300.0, height: 40)
                Spacer()
                
                Button(action: submitUpdate) {
                  Text("SUBMIT UPDATE TO THE GUIDE")
                    .padding()
                    .foregroundColor(Color.white)
                    .background(entry.isEmpty ? Color.secondary : Color.red)
                    .cornerRadius(40)
                }
                .disabled(entry.isEmpty)
                .frame(width: 300.0)
                
                Spacer()
                List {
                  ForEach(pubnubStore.messages.reversed()) { message in
                    VStack(alignment: .leading) {
                      Text(message.messageType)
                      Text(message.messageText)
                    } // VStack
                  }
                } // List
            } // List
            .listStyle(InsetGroupedListStyle()) /// grouped appearance
           // .navigationBarTitle("Car", displayMode: .inline)
            /// navigationBarTitle (use navigationTitle for iOS14+) should be *inside* your NavigationView
            */
            /// otherwise, title won't show
        }
    //}
    
    func submitUpdate() {
      if !self.entry.isEmpty {
        pubnubStore.publish(update: EntryUpdate(update: self.entry))
        self.entry = ""
      }
      
      // Hides keyboard
      UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
        
        /*
        ZStack(alignment: .bottomTrailing) {
       
            ScrollView {
                
                Spacer().frame(width: 20, height: 20, alignment: .trailing)
                Image("hub_label").frame( height: 40, alignment: .leading)
                Spacer().frame(width: 30, height: 30, alignment: .trailing)
                ForEach(observedViewModel.plmDevice) { returned_device in
                    HStack {
                        Image("plm_icon").frame(width: 10, height: 10, alignment: .leading)
                        Spacer().frame(width: 50, height: 50, alignment: .trailing)
                        VStack(alignment: .leading) {
                            Text(returned_device.name)
                                .font(.title)
                                .fontWeight(.bold)
                            Text(returned_device.location)
                        } //VStack // VStack
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text(returned_device.state)
                            Text(returned_device.status)
                        } //VStack // VStack
                        
                    } //HStack // HStack
                    .frame(height: 40)
                    .padding(12)
                    
                } //person in

            } //ScrollView // ScrollView
            
   
            List(oceans, selection: $multiSelection) {
                Text($0.name)
            } // List
            
            Menu("Menu".uppercased()) {
                Button("Reverse", action: { observedViewModel.reverseOrder() })
                Button("Shuffle", action: { observedViewModel.shuffleOrder() })
                Button("Remove last", action: { observedViewModel.removeLastPerson() })
                Button("Remove first", action: { observedViewModel.removeFirstPerson() })
            }  //Menu // Menu
            .padding()
            
        } //ZStack // ZStack
        */
        
   // }  // body: some View
//} //struct DevicesView


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DevicesView()
    }
}
