//
//  MyDatePickerView.swift
//  MiscellaneousWatch Watch App
//
//  Created by Jinwoo Kim on 8/3/24.
//

import SwiftUI

struct MyDatePickerView: View {
    @State private var selectedDate: Date = .now
    
    var body: some View {
        DatePicker(
            selection: $selectedDate,
            displayedComponents: .date
        ) {
            Label("Select a Date", systemImage: "calendar")
        }
    }
}

#Preview {
    MyDatePickerView()
}
