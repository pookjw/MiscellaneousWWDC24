//
//  PresentationSizingView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 7/8/24.
//

import SwiftUI

// https://x.com/_silgen_name/status/1810329666173227069

struct PresentationSizingView: View {
    @State private var isPresenting = false
    @State private var sheetSize: CGSize = .init(width: 300.0, height: 300.0)
    
    var body: some View {
        Button("Present View") {
            isPresenting = true
        }
        .sheet(isPresented: $isPresenting, onDismiss: {
            sheetSize = .init(width: 300.0, height: 300.0)
        }) {
            VStack {
                Button("Set 200") {
                    withAnimation {
                        print(PagePresentationSizing.page.fitted(horizontal: false, vertical: true))
                        sheetSize = .init(width: 200.0, height: 200.0)
                    }
                }
                
                Button("Set 400") {
                    withAnimation {
                        sheetSize = .init(width: 400.0, height: 400.0)
                    }
                }
            }
            .overlay(content: {
                GeometryReader { proxy in
//                    Text(proxy.size.debugDescription)
                    let _: Void = print(proxy.size)
                }
                .allowsHitTesting(false)
            })
            .frame(width: 300.0, height: 300.0)
            .frame(idealWidth: sheetSize.width, idealHeight: sheetSize.height)
            // UIModalPresentationStyle 같은 것
//            .presentationSizing(.fitted.fitted(horizontal: false, vertical: true))
//            .presentationSizing(.fitted.sticky(horizontal: true, vertical: false))
//            .presentationSizing(.page.fitted(horizontal: false, vertical: true))
            .presentationSizing(CustomPresentationSizing().sticky(horizontal: false, vertical: false))
//            .presentationSizing(CustomPresentationSizing().fitted(horizontal: false, vertical: true))
        }
    }
}

// sticky : 크기가 안 작아지게 : 200 -> 300 -> 250 순으로 크기가 바뀌면 300
// fitting : Ideal Size를 어느 축에 적용할지. PresentationSizing.fitting으로 하면 무시되는듯?

fileprivate struct CustomPresentationSizing: PresentationSizing {
    func proposedSize(for root: PresentationSizingRoot, context: PresentationSizingContext) -> ProposedViewSize {
        for child in Mirror(reflecting: context).children {
            print("-", child.label!)
            print("     \(child.value)")
        }
        //
        //        return .init(width: 300.0, height: 300.0)
        //        return .init(root.sizeThatFits(.unspecified))
        return .unspecified
    }
}

#Preview {
    PresentationSizingView()
}
