//
//  UIKitPresenter.swift
//  MyApp
//
//  Created by Jinwoo Kim on 11/2/24.
//

import UIKit
import SwiftUI
import ImagePlayground

struct UIKitPresenter: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ViewController {
        ViewController()
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        
    }
    
    final class ViewController: UIViewController, ImagePlaygroundViewController.Delegate {
        override func loadView() {
            var configuration = UIButton.Configuration.plain()
            configuration.title = "Present"
            let button = UIButton(configuration: configuration)
            
            button.addAction(
                UIAction(
                    handler: { [weak self] _ in
                        guard let self else { return }
                        
                        let imagePlaygroundViewController = ImagePlaygroundViewController()
                        imagePlaygroundViewController.allowedGenerationStyles = ImagePlaygroundStyle.all
                        imagePlaygroundViewController.selectedGenerationStyle = .sketch
                        imagePlaygroundViewController.personalizationPolicy = .enabled // 사람 얼굴 선택
                        imagePlaygroundViewController.sourceImage = UIImage(named: "image")
                        imagePlaygroundViewController.concepts = [
                            ImagePlaygroundConcept.text("Cat"),
                            ImagePlaygroundConcept.extracted(from: "In a deep and mystical forest, a magical deer stands by a small lake shrouded in a soft, blue mist. The deer has shimmering silver fur and majestic golden antlers that emit a gentle light, illuminating the surroundings. Around the deer, small glowing butterflies gather, creating an enchanting scene. The night sky is filled with twinkling stars, and the moonlight bathes the forest, adding to the air of mystery and wonder.", title: "Magical Deer in the Forest")
                        ]
                        imagePlaygroundViewController.delegate = self
                        
                        present(imagePlaygroundViewController, animated: true)
                    }
                ), for: .primaryActionTriggered
            )
            
            button.isEnabled = ImagePlaygroundViewController.isAvailable
            
            view = button
        }
        
        func imagePlaygroundViewController(_ imagePlaygroundViewController: ImagePlaygroundViewController, didCreateImageAt imageURL: URL) {
            let button = view as! UIButton
            var configuration = button.configuration!
            configuration.background.image = UIImage(contentsOfFile: imageURL.relativePath)
            button.configuration = configuration
            
            imagePlaygroundViewController.dismiss(animated: true)
        }
        
        func imagePlaygroundViewControllerDidCancel(_ imagePlaygroundViewController: ImagePlaygroundViewController) {
            imagePlaygroundViewController.dismiss(animated: true)
        }
    }
}
