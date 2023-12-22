//
//  Forms.swift
//  Creating Forms in SwiftUI
//
//  Created by Flávio Silvério on 19/12/2023.
//

import SwiftUI
import PhotosUI

struct Forms: View {
    @State private var firstname: String = "John"
    @State private var lastname: String = "Smith"
    @State private var email: String = "JohnSmith@email.com"
    @State var date = Date(timeIntervalSinceReferenceDate: 0)
    
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image?
    @State private var shouldPresentPhotoPicker: Bool = false
    
    @State private var maxNotifications: Int = 5
    @State private var enablePush: Bool = false
    
    let themeOptions = [
        ThemeOptions.system.rawValue,
        ThemeOptions.dark.rawValue,
        ThemeOptions.light.rawValue
    ]
    
    @State private var theme: String = ThemeOptions.system.rawValue
    @State var globalScheme: ColorScheme = .light
    
    var body: some View {
        NavigationStack {
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
                                        avatarImage?
                                            .resizable()
                                            .frame(width: 80, height: 80)
                                            .aspectRatio(contentMode: .fit)
                                            .cornerRadius(40)
                                        
                                    }
                                })
                                .tint(globalScheme == ColorScheme.light ? .black : .white)
                                .photosPicker(isPresented: $shouldPresentPhotoPicker,
                                              selection: $avatarItem)                    }.onChange(of: avatarItem) {
                                    Task {
                                        if let loaded = try? await avatarItem?.loadTransferable(type: Image.self) {
                                            avatarImage = loaded
                                        } else {
                                            print("Failed")
                                        }
                                    }
                                }
                            
                            VStack {
                                Text(firstname + " " + lastname)
                                    .font(.title)
                                    .frame(maxWidth: .infinity,
                                           alignment: .leading)
                                
                                Text(email)
                                    .frame(maxWidth: .infinity,
                                           alignment: .leading)
                            }
                        }.listRowBackground(Color(UIColor.systemGroupedBackground))
                        
                        TextField("First name", text: $firstname)
                        TextField("Last name", text: $lastname)
                        TextField("Email", text: $email)
                        DatePicker("Date of Birth", selection: $date, displayedComponents: .date)
                    }
                    Section("Push Notifications") {
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
                                Text(t.description.capitalized).tag(t)
                                
                            }
                        }.pickerStyle(.navigationLink)
                            .onChange(of: theme) {
                                
                                switch theme {
                                case ThemeOptions.dark.rawValue:
                                    globalScheme = .dark
                                case ThemeOptions.light.rawValue:
                                    globalScheme = .light
                                default:
                                    globalScheme = .dark
                                }
                            }
                        
                    }
            }
            .navigationTitle(Text("Settings"))

        }
        .preferredColorScheme(globalScheme)
    }
}


#Preview {
    Forms()
}
