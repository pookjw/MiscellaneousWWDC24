//
//  PrivacyView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 7/30/24.
//

import SwiftUI

struct PrivacyView: View {
    var body: some View {
        ChildView()
        .redacted(reason: .privacy)
    }
}

extension PrivacyView {
    struct ChildView: View {
        @Environment(\.redactionReasons) private var redactionReasons: RedactionReasons
        
        var body: some View {
            VStack {
                Text(String(describing: redactionReasons))
                
                HStack {
                    Text("privacySensitive(_:)")
                    
                    Text("Hello World!")
                        .privacySensitive()
                }
            }
        }
    }
}

#Preview {
    PrivacyView()
}
