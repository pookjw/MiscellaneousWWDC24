//
//  CustomBaselineView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 9/19/24.
//

import SwiftUI

struct CustomBaselineView: View {
    var body: some View {
        HStack(alignment: .firstTextBaseline) { 
            MyCustomView()
                .frame(maxWidth: .infinity)
                .background { 
                    Color.orange
                }
            
            Text("Foo")
                .background { 
                    Color.cyan
                }
        }
    }
}

fileprivate struct MyCustomView: UIViewRepresentable {
    final class ContentView: UIView {
        @objc(_baselineOffsetsAtSize:) func _baselineOffsets(at size: CGSize) -> CGPoint {
            return .init(x: 100.0, y: 100.0)
        }
    }
    
    func makeUIView(context: Context) -> ContentView {
        .init()
    }
    
    func updateUIView(_ uiView: ContentView, context: Context) {
        
    }
}

#Preview {
    CustomBaselineView()
}
