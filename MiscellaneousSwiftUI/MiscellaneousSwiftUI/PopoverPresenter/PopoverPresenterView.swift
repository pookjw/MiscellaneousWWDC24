//
//  PopoverPresenterView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 7/8/24.
//

#if !os(tvOS)

import SwiftUI
import ObjectiveC

struct PopoverPresenterView: View {
    @State private var isPresented: Bool = false
    
    var body: some View {
        Button("Popover") { 
            isPresented = true
        }
        .popover(isPresented: $isPresented, attachmentAnchor: .rect(.bounds)) { 
            Color.green
//                .padding()
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//            BlueView()
//                .frame(width: 300, height: 300)
                .ignoresSafeArea()
                .presentationSizing(.form)
#if os(macOS)
//                .popover(hasFullSizeContent: true, behavior: .applicationDefined)
#endif
        }
    }
}

#if !os(macOS)
fileprivate struct BlueView: UIViewRepresentable {
    func makeUIView(context: Context) -> MyView {
        let uiView: MyView = .init()
        uiView.backgroundColor = .systemBlue
        return uiView
    }
    
    func updateUIView(_ uiView: MyView, context: Context) {
        
    }
    
    typealias UIViewType = MyView
    
    final class MyView: UIView {
        
    }
}
#endif

#if os(macOS)

extension View {
    func popover(hasFullSizeContent: Bool? = nil, behavior: NSPopover.Behavior? = nil) -> some View {
        background {
            PopoverModifierView(hasFullSizeContent: hasFullSizeContent, behavior: behavior)
                .allowsHitTesting(false)
                .frame(width: .zero, height: .zero)
                .opacity(.zero)
        }
    }
    
    @available(*, deprecated)
    func popover() -> some View {
        self
    }
}

fileprivate struct PopoverModifierView: NSViewRepresentable {
    private let hasFullSizeContent: Bool?
    private let behavior: NSPopover.Behavior?
    
    init(hasFullSizeContent: Bool?, behavior: NSPopover.Behavior?) {
        self.hasFullSizeContent = hasFullSizeContent
        self.behavior = behavior
    }
    
    func makeNSView(context: Context) -> ContentView {
        .init(hasFullSizeContent: hasFullSizeContent, behavior: behavior)
    }
    
    func updateNSView(_ nsView: ContentView, context: Context) {
        nsView.hasFullSizeContent = hasFullSizeContent
        nsView.behavior = behavior
    }
    
    final class ContentView: NSView {
        var hasFullSizeContent: Bool? {
            didSet {
                guard let hasFullSizeContent: Bool else { return }
                popover?.hasFullSizeContent = hasFullSizeContent
            }
        }
        
        var behavior: NSPopover.Behavior? {
            didSet {
                guard let behavior: NSPopover.Behavior else { return }
                // SwiftUI.PopoverBridge.updatePopover에서 마지막으로 업데이트 해서 의미 없음
                popover?.behavior = behavior
            }
        }
        
        private var popover: NSPopover? {
            guard let window: NSWindow,
                  window.isKind(of: objc_lookUpClass("_NSPopoverWindow")!)
            else {
                return nil
            }
            
            let popoverMethod: Method = class_getInstanceMethod(objc_lookUpClass("_NSPopoverWindow"), Selector(("_popover")))!
            let popoverIMP: IMP = method_getImplementation(popoverMethod)
            let castedPopoverIMP = unsafeBitCast(popoverIMP, to: (@convention(c) (Any, Selector) -> NSPopover?).self)
            
            let popover: NSPopover? = castedPopoverIMP(window, Selector(("_popover")))
            return popover
        }
        
        init(hasFullSizeContent: Bool?, behavior: NSPopover.Behavior?) {
            self.hasFullSizeContent = hasFullSizeContent
            self.behavior = behavior
            super.init(frame: .zero)
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidMoveToWindow() {
            super.viewDidMoveToWindow()
            
            if let popover: NSPopover {
                if let hasFullSizeContent: Bool {
                    popover.hasFullSizeContent = hasFullSizeContent
                }
                
                if let behavior: NSPopover.Behavior {
                    popover.behavior = behavior
                }
            }
        }
    }
}

#endif

#Preview {
    PopoverPresenterView()
}

#endif
