//
//  FocusedTextFieldView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 7/15/24.
//

import SwiftUI

struct FocusedTextFieldView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @FocusState private var focusedField: Field?
    
    var body: some View {
        Form { 
            TextField("Username", text: $username)
                .focused($focusedField, equals: .usernameField)
            
            TextField("Password", text: $password, axis: .vertical)
                .focused($focusedField, equals: .passwordField)
            
            Button("Sign In") { 
                if username.isEmpty {
                    focusedField = .usernameField
                } else if password.isEmpty {
                    focusedField = .passwordField
                } else {
                    print(username, password)
                }
            }
        }
        .defaultFocus($focusedField, .usernameField, priority: .automatic)
        .onChange(of: focusedField, initial: true) { oldValue, newValue in
            print(newValue)
        }
    }
}

extension FocusedTextFieldView {
    fileprivate enum Field: Hashable {
        case usernameField
        case passwordField
    }
}

#Preview {
    FocusedTextFieldView()
}
