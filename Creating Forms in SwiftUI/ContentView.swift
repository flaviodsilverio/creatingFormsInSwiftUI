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
    @State private var age: Int = 18
    @State private var enablePush: Bool = false
    
    @State var globalScheme: ColorScheme = .light

    @State var date = Date()
    
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image?
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack{
                        VStack {
                                    PhotosPicker("Select avatar", selection: $avatarItem, matching: .images)

                                    avatarImage?
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 300, height: 300)
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
                            
                        Image(systemName: "person")                        .resizable()
                            .frame(width: 60, height: 60)
                        
                        VStack {
                            Text("John Smith")
                                .font(.title)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Premium member").frame(maxWidth: .infinity, alignment: .leading)
                        }
                        Spacer()
                    }
                }
                .listRowBackground(Color(UIColor.systemGroupedBackground))
                
                Section {
                    TextField("First name", text: $firstname)
                    TextField("Last name", text: $lastname)
                    Stepper("Age \(age)", value: $age, in: 0...99)
                    TextField("Email", text: $email)
                    DatePicker("Birth", selection: $date, displayedComponents: .date)
                }

                Section("Notifications") {

                    Toggle(isOn: $enablePush) {
                        Text("Push Notifications")
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
