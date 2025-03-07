//
//  View+Pop.swift
//  MyCanvas
//
//  Created by Jinwoo Kim on 3/7/25.
//

import SwiftUI

extension View {
    func pop(_ pop: Bool) -> some View {
        self
            .overlay {
                PopView(pop: pop)
                    .frame(width: .zero, height: .zero)
            }
    }
}

fileprivate struct PopView: UIViewControllerRepresentable {
    let pop: Bool
    
    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if pop {
            uiViewController.navigationController?.popViewController(animated: true)
        }
    }
}
