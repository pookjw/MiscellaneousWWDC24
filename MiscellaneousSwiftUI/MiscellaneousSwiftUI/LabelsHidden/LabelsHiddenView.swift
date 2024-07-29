//
//  LabelsHiddenView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 7/30/24.
//

import SwiftUI

struct LabelsHiddenView: View {
    @State private var toggle1 = false
    @State private var toggle2 = false
    
    var body: some View {
        VStack {
            Toggle(isOn: $toggle1) {
                
            }
            .labelsHidden()
            
            Toggle(isOn: $toggle2) {
                
            }
        }
    }
}

#Preview {
    LabelsHiddenView()
}
