//
//  FullScreenVideoPlayerView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 7/6/24.
//

#if os(visionOS)

import SwiftUI
import AVKit
import UniformTypeIdentifiers

struct FullScreenVideoPlayerView: View {
    var body: some View {
        VideoPlayer(
            player: .init(url: Bundle.main.url(forResource: "video", withExtension: UTType.mpeg4Movie.preferredFilenameExtension)!),
            videoOverlay: { 
                VideoPlayerEnableFullScreenView()
            }
        )
    }
}

fileprivate struct VideoPlayerEnableFullScreenView: UIViewRepresentable {
    func makeUIView(context: Context) -> ContentView {
        .init()
    }
    
    func updateUIView(_ uiView: ContentView, context: Context) {
        
    }
    
    typealias UIViewType = ContentView
    
    final class ContentView: UIView {
        override func didMoveToWindow() {
            super.didMoveToWindow()
            
            guard window != nil else { return }
            
            var parentViewController: UIViewController? = perform(Selector(("_viewControllerForAncestor")))?.takeUnretainedValue() as? UIViewController
            
            while let _parentViewController: UIViewController = parentViewController {
                if let playerViewController: AVPlayerViewController = _parentViewController as? AVPlayerViewController {
                    let imp: IMP = playerViewController.method(for: Selector(("setAllowsEnteringFullScreen:")))
                    let casted = unsafeBitCast(imp, to: (@convention(c) (Any, Selector, ObjCBool) -> Void).self)
                    
                    DispatchQueue.main.async {
                        casted(playerViewController, Selector(("setAllowsEnteringFullScreen:")), .init(true))
                    }
                    
                    
                    break
                }
                
                parentViewController = _parentViewController.parent
            }
        }
    }
}

#Preview {
    FullScreenVideoPlayerView()
}

#endif
