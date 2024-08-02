//
//  Demo.swift
//  MiscellaneousWatch Watch App
//
//  Created by Jinwoo Kim on 7/31/24.
//

import SwiftUI

enum Demo: Int, Identifiable, CaseIterable {
    case digitalCrownRotation
    case myTab
    case mySliderView
    
    var id: Int {
        rawValue
    }
    
    @ViewBuilder
    func makeView() -> some View {
        switch self {
        case .digitalCrownRotation:
            DigitalCrownRotationView()
        case .myTab:
            MyTabView()
        case .mySliderView:
            MySliderView()
        }
    }
}
