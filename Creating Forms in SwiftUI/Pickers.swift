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
    
    var body: some View {
        NavigationStack {
            List {
                Picker("Picker Name",selection: $selected) {
                    ForEach(selectionOptions, id: \.self) {
                        Text($0)
                    }
                }.pickerStyle(.navigationLink)
            }
        }
//        Picker("My selection", selection: $selected, content: {
//                    ForEach(selectionOptions, id: \.self) { t in
//                        Text(t).tag(t)
//                        
//                    }
//            }).pickerStyle(.navigationLink)
        
        
    }
}

#Preview {
    Pickers()
}
