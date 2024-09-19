//
//  MyViewThatFits.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 9/19/24.
//

import SwiftUI

struct MyViewThatFits: View {
    var body: some View {
        VStack {
            ViewThatFits {
                Color.red
                    .frame(width: 300.0)
                Color.orange
                    .frame(width: 200.0)
                Color.yellow
                    .frame(width: 100.0)
            }
            .frame(width: 100.0)
            
            ViewThatFits {
                Color.red
                    .frame(width: 300.0)
                Color.orange
                    .frame(width: 200.0)
                Color.yellow
                    .frame(width: 100.0)
            }
            .frame(width: 200.0)
            
            ViewThatFits {
                Color.red
                    .frame(width: 300.0)
                Color.orange
                    .frame(width: 200.0)
                Color.yellow
                    .frame(width: 100.0)
            }
            .frame(width: 300.0)
        }
    }
}

#Preview {
    MyViewThatFits()
}
