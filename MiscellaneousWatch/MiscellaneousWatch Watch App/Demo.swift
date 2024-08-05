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
    case mySlider
    case myAlert
    case myDatePicker
    case myToggle
    case myStepper
    case myTimeline
    case myVideoPlayer
    
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
        case .mySlider:
            MySliderView()
        case .myAlert:
            MyAlertView()
        case .myDatePicker:
            MyDatePickerView()
        case .myToggle:
            MyToggleView()
        case .myStepper:
            MyStepperView()
        case .myTimeline:
            MyTimelineView()
        case .myVideoPlayer:
            MyVideoPlayerView()
        }
    }
}
