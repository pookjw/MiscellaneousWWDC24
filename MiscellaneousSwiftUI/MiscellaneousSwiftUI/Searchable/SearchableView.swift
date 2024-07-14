//
//  SearchableView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 7/12/24.
//

import SwiftUI

struct SearchableView: View {
    @State private var searchText: String = "Hello, World!"
    var body: some View {
        Text(searchText)
            .searchable(
                text: $searchText,
                tokens: <#T##Binding<RandomAccessCollection & RangeReplaceableCollection>#>,
                suggestedTokens: <#T##Binding<RandomAccessCollection & RangeReplaceableCollection>#>, 
                isPresented: <#T##Binding<Bool>#>,
                placement: <#T##SearchFieldPlacement#>,
                prompt: "Placeholder!", 
                token: <#T##(Identifiable) -> View#>
            )
    }
}

#Preview {
    SearchableView()
}
