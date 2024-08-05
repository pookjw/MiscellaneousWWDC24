//
//  MyVideoPlayerView.swift
//  MiscellaneousWatch Watch App
//
//  Created by Jinwoo Kim on 8/5/24.
//

import SwiftUI
import AVKit
import AVFoundation
import UniformTypeIdentifiers

struct MyVideoPlayerView: View {
    @State private var player: AVPlayer = .init(url: Bundle.main.url(forResource: "0", withExtension: UTType.mpeg4Movie.preferredFilenameExtension)!)
    
    var body: some View {
        VideoPlayer(player: player) { 
            Text("Test")
                .background { 
                    Color.cyan // handleWatchActions
                }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    MyVideoPlayerView()
}
