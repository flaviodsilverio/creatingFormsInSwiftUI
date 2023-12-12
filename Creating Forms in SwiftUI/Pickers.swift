//
//  Pickers.swift
//  Creating Forms in SwiftUI
//
//  Created by Flávio Silvério on 23/11/2023.
//

import SwiftUI

struct Pickers: View {
    @State private var selected: String = ""
    
    private let selectionOptions = [
        "my first option",
        "my second option",
        "my third option"]
    
    @State private var date = Date.now
    @State private var bgColor =
        Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)
    
    var body: some View {
                NavigationStack {
                    List {
                        Picker("Picker Name",selection: $selected) {
                            ForEach(selectionOptions, id: \.self) {
                                Text($0)
                            }
                        }.pickerStyle(.palette)
                    }
                }
        
    }
}

#Preview {
    Pickers()
}
