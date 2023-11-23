//
//  ContentView.swift
//  Creating Forms in SwiftUI
//
//  Created by Flávio Silvério on 20/11/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var firstname: String = ""
    @State private var lastname: String = ""
    @State private var email: String = ""
    
    let themeOptions = ["System", "Dark", "Light"]

    @State private var theme: String = "System"
    @State private var age: Int = 18
    @State private var enablePush: Bool = false
    
    @State var globalScheme: ColorScheme = .light

    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack{
                        
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
                }

                Section("Notifications") {

                    Toggle(isOn: $enablePush) {
                        Text("Push Notifications")
                    }
                }
                
                Section {
                    Picker("App Theme", selection: $theme) {
                        ForEach(themeOptions, id: \.self) { t in
                            Text(t).tag(t)
                            
                        }
                    }.onChange(of: theme) {
                        
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
