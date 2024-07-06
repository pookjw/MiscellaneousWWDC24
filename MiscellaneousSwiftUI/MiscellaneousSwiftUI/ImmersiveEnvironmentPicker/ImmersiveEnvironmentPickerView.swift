//
//  ImmersiveEnvironmentPickerView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 7/4/24.
//

#if os(visionOS)

// .cameraAnchor API (AVKit)
// https://developer.apple.com/documentation/swiftui/view/oncameracaptureevent(isenabled:action:)
// https://www.lovelili.fun/documentation/avkit/videoplayer/navigationtransition(_:)

import SwiftUI
import AVKit
import UniformTypeIdentifiers

struct ImmersiveEnvironmentPickerView: View {
    var body: some View {
        VideoPlayerView(player: .init(url: Bundle.main.url(forResource: "video", withExtension: UTType.mpeg4Movie.preferredFilenameExtension)!))
            .immersiveEnvironmentPicker {
                // SwiftUI.MenuStyleContext를 지원해야 해서 Custom View는 안 됨
                MyView()
                
                Button("Button?") { 
                    
                }
            }
    }
}

fileprivate struct VideoPlayerView: UIViewControllerRepresentable {
    private let player: AVPlayer
    
    init(player: AVPlayer) {
        self.player = player
    }
    
    final class Coordinator: NSObject, AVPlayerViewControllerDelegate {
        
    }
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let playerViewController: AVPlayerViewController = .init()
        playerViewController.delegate = context.coordinator
        playerViewController.player = player
        playerViewController.entersFullScreenWhenPlaybackBegins = true
        return playerViewController
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        uiViewController.player = player
    }
    
    func makeCoordinator() -> Coordinator {
        .init()
    }
}

fileprivate struct MyView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ContentViewController {
        .init()
    }
    
    func updateUIViewController(_ uiViewController: ContentViewController, context: Context) {
        
    }
    
    final class ContentViewController: UIViewController {
        override func loadView() {
            let label: UILabel = .init()
            label.text = "Hello World!"
            label.font = .preferredFont(forTextStyle: .title1)
            view = label
        }
    }
}

#Preview {
    ImmersiveEnvironmentPickerView()
}

#endif
