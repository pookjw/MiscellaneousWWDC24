//
//  FocusedTVMacView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 7/15/24.
//

#if os(macOS) || os(tvOS)

// https://x.com/_silgen_name/status/1812872620733559010

import SwiftUI

// TODO: onMoveCommand (tvOS)
// TODO: macOS에서 Search Bar 써보기 + Token이 있는지

struct FocusedTVMacView: View {
    enum FocusedField {
        case firstName, lastName
    }
    
    @Namespace private var namespace: Namespace.ID
    @State private var firstName = ""
    @State private var lastName = ""
    @FocusState private var focusedField: FocusedField?
    @Environment(\.resetFocus) private var resetFocus: ResetFocusAction

    var body: some View {
        Form {
            TextField("First name", text: $firstName)
                .onSubmit {
                    resetFocus(in: namespace)
                }
                .focused($focusedField, equals: .firstName)

            TextField("Last name", text: $lastName)
                .focused($focusedField, equals: .lastName)
                .prefersDefaultFocus(true, in: namespace)
            
            Button("Reset") { 
                resetFocus(in: namespace)
            }
        }
        .defaultFocus($focusedField, .lastName, priority: .userInitiated)
        .focusScope(namespace)
    }
}

#Preview {
    FocusedTVMacView()
}

#endif
