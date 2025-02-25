//
//  HomeView.swift
//  MyApp
//
//  Created by Jinwoo Kim on 11/2/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        List {
            NavigationLink {
                SwiftUIPresenter()
            } label: {
                Text("SwiftUI Presenter")
            }
            
            NavigationLink {
                UIKitPresenter()
            } label: {
                Text("UIKit Presenter")
            }
            
            NavigationLink {
                ObjCUIKitPresenter()
                    .ignoresSafeArea()
            } label: {
                Text("Objective-C UIKit Presenter")
            }
            
            if #available(iOS 18.4, *) {
                NavigationLink {
                    ImageCreatorView()
                } label: {
                    Text("Image Creator")
                }
                
                NavigationLink {
                    ObjCImageCreatorPresentor()
                        .ignoresSafeArea()
                } label: {
                    Text("Objective-C Image Creator")
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
