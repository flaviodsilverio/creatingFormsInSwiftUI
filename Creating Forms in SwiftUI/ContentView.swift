//
//  ContentView.swift
//  Creating Forms in SwiftUI
//
//  Created by Flávio Silvério on 20/11/2023.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var firstname: String = ""
    @State private var lastname: String = ""
    @State private var email: String = ""
    
    let themeOptions = ["System", "Dark", "Light"]
    
    @State private var theme: String = "System"
    @State private var maxNotifications: Int = 5
    @State private var enablePush: Bool = false
    
    @State var globalScheme: ColorScheme = .light
    
    @State var date = Date()
    
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image?
    @State private var shouldPresentPhotoPicker: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack{
                        VStack {
                                Button(action: {
                                    shouldPresentPhotoPicker = true;
                                }, label: {
                                    if(avatarImage == nil) {
                                        Image(systemName: "person").font(.system(size: 60, weight: .medium))
                                    } else {
                                        avatarImage
                                    }
                                })
                                .tint(globalScheme == ColorScheme.light ? .black : .white)
                                .frame(width: 80, height: 80)
                                .clipped()
                                .photosPicker(isPresented: $shouldPresentPhotoPicker, selection: $avatarItem)

                                
//                                Image(systemName: "person")
//                                    .resizable()
//                                    .frame(width: 60, height: 60)

//                            } else {
//                                avatarImage?
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fill)
//                                    .frame(width: 60, height: 60)
//                                    .clipped()
//                                    .cornerRadius(30)
//                                    .photosPicker(isPresented: $shouldPresentPhotoPicker, selection: $avatarItem)
//                            }
                                

                        }
                        .onChange(of: avatarItem) {
                            Task {
                                if let loaded = try? await avatarItem?.loadTransferable(type: Image.self) {
                                    avatarImage = loaded
                                } else {
                                    print("Failed")
                                }
                            }
                        }
                    
                        
                        VStack {
                            Text("John Smith")
                                .font(.title)
                                .frame(maxWidth: .infinity,
                                       alignment: .leading)
                            
                            Text("Premium member")
                                .frame(maxWidth: .infinity,
                                       alignment: .leading)
                        }
                        Spacer()
                    }
                }
                .listRowBackground(Color(UIColor.systemGroupedBackground))
                
                Section {
                    TextField("First name", text: $firstname)
                    TextField("Last name", text: $lastname)
                    TextField("Email", text: $email)
                    DatePicker("Date of Birth", selection: $date, displayedComponents: .date)
                }
                
                Section("Notifications") {
                    Toggle(isOn: $enablePush) {
                        Text("Push Notifications")
                    }
                    
                    if(enablePush) {
                        Stepper("Max daily notifications: \(maxNotifications)", value: $maxNotifications, in: 0...10)
                    }
                }
                
                Section("Customisation") {
                    Picker("App Theme",
                           selection: $theme) {
                        ForEach(themeOptions, id: \.self) { t in
                            Text(t).tag(t)
                            
                        }
                    }.pickerStyle(.navigationLink)
                        .onChange(of: theme) {
                            
                            switch theme {
                            case "Dark":
                                globalScheme = .dark
                            case "Light":
                                globalScheme = .light
                            default:
                                globalScheme = .dark
                            }
                        }
                    
                }
            }
            .navigationTitle(Text("Settings"))
            .preferredColorScheme(globalScheme)
        }
        
    }
}

#Preview {
    ContentView()
}
