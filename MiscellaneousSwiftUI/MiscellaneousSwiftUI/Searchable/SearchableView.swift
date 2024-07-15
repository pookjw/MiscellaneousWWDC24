//
//  SearchableView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 7/12/24.
//

import SwiftUI

struct SearchableView: View {
    @State private var searchText: String = "Hello, World!"
    @State private var tokens: [Token] = [
        .init(title: "123")
    ]
    @State private var suggestedTokens: [Token] = [
        .init(title: "Suggested! 1"),
        .init(title: "Suggested! 2")
    ]
    @State private var isPresented: Bool = false
    @State private var scope: String = "1"
    
    var body: some View {
        Button("Add Token", action: { 
            tokens.append(.init(title: Date.now.description))
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
#if !os(tvOS) && !os(macOS)
        .searchable(
            text: $searchText,
            tokens: $tokens,
            suggestedTokens: $suggestedTokens,
            isPresented: $isPresented,
            placement: .navigationBarDrawer,
            prompt: "Placeholder!"
        ) { token in
            Label(token.title, systemImage: "rectangle.portrait.and.arrow.right")
        }
//        .searchable(text: $searchText) {
//            Text("🍎").searchCompletion("apple")
//            Text("🍐").searchCompletion("pear")
//            Text("🍌").searchCompletion("banana")
//        }
        .searchScopes($scope, activation: .onSearchPresentation) { 
            Text("Scope 1").tag("1")
            Text("Scope 2").tag("2")
        }
        .searchPresentationToolbarBehavior(.avoidHidingContent) // https://stackoverflow.com/a/78184592/17473716
        .searchDictationBehavior(.inline(activation: .onLook))
        .onChange(of: scope, initial: false) { oldValue, newValue in
            print(newValue)
        }
#else
        .searchable(text: $searchText, placement: .automatic, prompt: "Prompt!") {
            ForEach(tokens) { token in
                Text(token.title).searchCompletion(token.title)
            }
            Text("🍎").searchCompletion("apple")
            Text("🍐").searchCompletion("pear")
            Text("🍌").searchCompletion("banana")
        }
#endif
    }
}

extension SearchableView {
    fileprivate struct Token: Identifiable {
        let title: String
        var id: String { title }
    }
}

#Preview {
    SearchableView()
}
