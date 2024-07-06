//
//  MyDocumentLaunchView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 7/3/24.
//

#if os(iOS) || os(visionOS)

// https://x.com/_silgen_name/status/1809548907548143771
// DocumentGroupLaunchScene은 UIKit 처럼 Info.plist의 설정을 따름. 그래서 for contentTypes: [UTType] 및 onDocumentOpen이 존재하지 않음

import SwiftUI

struct MyDocumentLaunchView: View {
    var body: some View {
        DocumentLaunchView(
            "Hello World!",
            for: [.png]
        ) {
//            Button("Button 1") {
//                
//            }
            
            NewDocumentButton("Create", contentType: .gif)
            
            // 안 됨...
            Menu("Menu 2") {
                Button("Button") {
                    
                }
            }
        } onDocumentOpen: { url in
//            print(url)
            Color.blue
        } background: {
            Color.orange
        } backgroundAccessoryView: { proxy in
            Image("robot")
                .resizable()
                .scaledToFit()
                .frame(width: 300.0, height: 300.0)
                .position(x: proxy.titleViewFrame.maxX, y: proxy.titleViewFrame.minY)
        } overlayAccessoryView: { proxy in
            Image("robot")
                .resizable()
                .scaledToFit()
                .frame(width: 300.0, height: 300.0)
                .position(x: proxy.titleViewFrame.minX, y: proxy.titleViewFrame.maxY - 300.0)
        }

        // -[UIDocumentBrowserViewController setConfiguration:]
    }
}

#Preview {
    MyDocumentLaunchView()
}

#endif
