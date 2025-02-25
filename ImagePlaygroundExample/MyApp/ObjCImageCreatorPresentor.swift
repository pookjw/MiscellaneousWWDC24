//
//  ObjCImageCreatorPresentor.swift
//  MyApp
//
//  Created by Jinwoo Kim on 2/25/25.
//

import SwiftUI

@available(iOS 18.4, *)
struct ObjCImageCreatorPresentor: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some ObjCImageCreatorViewController {
        ObjCImageCreatorViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
