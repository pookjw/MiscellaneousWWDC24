//
//  WorldTrackingLimitationView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 7/29/24.
//

#if os(visionOS)

import SwiftUI

// _MRUIWindowSceneWorldTrackingCapabilitiesDidChange
struct WorldTrackingLimitationView: View {
    @Environment(\.worldTrackingLimitations) private var worldTrackingLimitations: Set<WorldTrackingLimitation>
    
    var body: some View {
        Form {
            LabeledContent("Orientation", value: worldTrackingLimitations.contains(.orientation) ? "Limited" : "Not Limited")
            
            LabeledContent("Translation", value: worldTrackingLimitations.contains(.translation) ? "Limited" : "Not Limited")
        }
    }
}

#Preview {
    WorldTrackingLimitationView()
}

#endif
