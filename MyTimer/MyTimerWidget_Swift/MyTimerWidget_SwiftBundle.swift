//
//  MyTimerWidget_SwiftBundle.swift
//  MyTimerWidget_Swift
//
//  Created by Jinwoo Kim on 7/29/24.
//

import WidgetKit
import SwiftUI

@main
struct MyTimerWidget_SwiftBundle: WidgetBundle {
    var body: some Widget {
        MyTimerWidget_Swift()
        MyTimerWidget_SwiftControl()
        MyTimerWidget_SwiftLiveActivity()
    }
}
