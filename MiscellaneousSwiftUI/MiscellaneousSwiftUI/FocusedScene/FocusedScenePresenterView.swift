//
//  FocusedScenePresenterView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 7/15/24.
//

#if !os(tvOS)

import SwiftUI

struct FocusedScenePresenterView: View {
    @Environment(\.openWindow) private var openWindow: OpenWindowAction
    
    var body: some View {
        Button("Present") { 
            openWindow(id: "FocusedScenePresenter")
        }
    }
}

extension FocusedScenePresenterView {
    struct Scene: SwiftUI.Scene {
        @State private var object: Object = .init()
        
        var body: some SwiftUI.Scene {
            WindowGroup(id: "FocusedScenePresenter") { 
                VStack {
                    TextFieldView()
                    
                    Color.clear
                        .focusedSceneValue(object)
                    
                    SceneContentView()
                }
            }
        }
    }
    
    struct SceneContentView: View {
        @FocusedValue(Object.self) private var object: Object?
        @FocusedValue(\.action) private var action: (() -> Void)?
        
        var body: some View {
            Button("Button") {
                print(object != nil) // true
                action?()
                
                Task {
                    try? await Task.sleep(for: .seconds(2))
                    print(object != nil) // true
                }
            }
        }
    }
    
    struct TextFieldView: View {
        @State private var text: String = ""
        @FocusState private var textFieldFocusState: Bool
        
        var body: some View {
            Group {
                TextField("Text", text: $text)
                    .focused($textFieldFocusState)
                    .focusedSceneValue(\.action) {
                        textFieldFocusState = true
                    }
                    .padding()
            }
                .defaultFocus($textFieldFocusState, true, priority: .userInitiated)
        }
    }
    
    @Observable
    final class Object {}
}

fileprivate struct ActionKey: FocusedValueKey {
    typealias Value = () -> Void
}

extension FocusedValues {
    fileprivate var action: (() -> Void)? {
        get {
            self[ActionKey.self]
        }
        set {
            self[ActionKey.self] = newValue
        }
    }
}

#Preview {
    FocusedScenePresenterView()
}

#endif
