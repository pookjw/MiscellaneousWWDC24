//
//  TextInputCompletionView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 7/30/24.
//

#if os(macOS)

import SwiftUI

struct TextInputCompletionView: View {
    @State private var text: String = ""
    
    var body: some View {
        TextField("Placeholder", text: $text)
            .textInputSuggestions {
                Text("The Fillmore")
                    .textInputCompletion("1805 Geary Blvd, San Francisco")
                Text("The Catalyst")
                    .textInputCompletion("1011 Pacific Ave, Santa Cruz")
                Text("Rio Theatre")
                    .textInputCompletion("1205 Soquel Ave, Santa Cruz")
            }
    }
}

#Preview {
    TextInputCompletionView()
}

#endif
