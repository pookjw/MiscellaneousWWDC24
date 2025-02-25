//
//  ObjCUIKitPresenter.swift
//  MyApp
//
//  Created by Jinwoo Kim on 11/2/24.
//

import SwiftUI

struct ObjCUIKitPresenter: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ObjCUIKitViewController {
        ObjCUIKitViewController()
    }
    
    func updateUIViewController(_ uiViewController: ObjCUIKitViewController, context: Context) {
        
    }
}
