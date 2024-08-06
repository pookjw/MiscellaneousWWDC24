//
//  MyPhotoPickerView.swift
//  MiscellaneousWatch Watch App
//
//  Created by Jinwoo Kim on 8/6/24.
//

import SwiftUI
import PhotosUI

struct MyPhotoPickerView: View {
    @State private var selectedItems: [PhotosPickerItem] = []
    
    var body: some View {
        PhotosPicker(selection: $selectedItems) {
            Text("Open")
        }
    }
}

#Preview {
    MyPhotoPickerView()
}
