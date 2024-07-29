//
//  Utils.swift
//  MyTimer
//
//  Created by Jinwoo Kim on 7/29/24.
//

import WidgetKit

@_expose(Cxx, "reloadAllTimelines")
public func reloadAllTimelines() {
    Task {
        WidgetCenter.shared.reloadAllTimelines()
        ControlCenter.shared.reloadAllControls()
        
        try! await ControlCenter.shared.currentControls()
    }
}
