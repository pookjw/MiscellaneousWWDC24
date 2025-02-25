//
//  SwiftUIPresenter.swift
//  MyApp
//
//  Created by Jinwoo Kim on 11/2/24.
//

import SwiftUI
import ImagePlayground

struct SwiftUIPresenter: View {
    @Environment(\.supportsImagePlayground) private var supportsImagePlayground
    
    @State private var isPresented = false
    @State private var resultImage: Image?
    
    var body: some View {
        Button("Present") {
            isPresented = true
        }
        .disabled(!supportsImagePlayground)
        .background {
            if let resultImage {
                resultImage
            }
        }
        .imagePlaygroundSheet(
            isPresented: $isPresented,
            concepts: [
                ImagePlaygroundConcept.text("Cat"),
                ImagePlaygroundConcept.extracted(from: "In a deep and mystical forest, a magical deer stands by a small lake shrouded in a soft, blue mist. The deer has shimmering silver fur and majestic golden antlers that emit a gentle light, illuminating the surroundings. Around the deer, small glowing butterflies gather, creating an enchanting scene. The night sky is filled with twinkling stars, and the moonlight bathes the forest, adding to the air of mystery and wonder.", title: "Magical Deer in the Forest")
            ],
            sourceImage: Image("image"),
            onCompletion: { url in
                resultImage = Image(uiImage: UIImage(contentsOfFile: url.relativePath)!)
            },
            onCancellation: {}
        )
        .conditional { view in
            if #available(iOS 18.4, *) {
                view
                    .imagePlaygroundGenerationStyle(.illustration, in: ImagePlaygroundStyle.all)
                    .imagePlaygroundPersonalizationPolicy(.enabled) // 사람 얼굴 선택
            } else {
                view
            }
        }
    }
}

extension View {
    fileprivate func conditional<T: View>(@ViewBuilder _ block: (Self) -> T) -> T {
        block(self)
    }
}

#Preview {
    SwiftUIPresenter()
}
