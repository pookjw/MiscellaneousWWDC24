//
//  ImmersiveEnvironmentPickerView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 7/4/24.
//

#if os(visionOS)

import SwiftUI
import UIKit
import AVKit
import UniformTypeIdentifiers

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

struct ImmersiveEnvironmentPickerView: View {
    var body: some View {
        VideoPlayerView(player: .init(url: Bundle.main.url(forResource: "video", withExtension: UTType.mpeg4Movie.preferredFilenameExtension)!))
            .immersiveEnvironmentPicker { 
                Button("Hello") { 
                    
                }
            }
    }
}

#Preview {
    ImmersiveEnvironmentPickerView()
}

#endif
