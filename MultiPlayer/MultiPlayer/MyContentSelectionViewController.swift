//
//  MyContentSelectionViewController.swift
//  MultiPlayer
//
//  Created by Jinwoo Kim on 7/5/24.
//

import UIKit
import AVKit
import UniformTypeIdentifiers

@MainActor
final class MyContentSelectionViewController: AVContentSelectionViewController {
    static let shared: MyContentSelectionViewController = .init()
    
    @ViewLoading private var collectionView: UICollectionView
    @ViewLoading private var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, Void>
    
    let playerViewControllers: [AVPlayerViewController] = .init(unsafeUninitializedCapacity: 8) { buffer, initializedCount in
        let windowScene: UIWindowScene = UIApplication
            .shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { windowScene in
                return windowScene.session.configuration.delegateClass == DefaultSceneDelegate.self
            }!
        
        for index in 0..<buffer.count {
            let url: URL = Bundle.main.url(forResource: index.description, withExtension: UTType.mpeg4Movie.preferredFilenameExtension)!
            let playerViewController: AVPlayerViewController = .init()
            playerViewController.player = .init(url: url)
            
            playerViewController.experienceController.allowedExperiences = .recommended(including: [.multiView, .embedded, .expanded])
            playerViewController.experienceController.configuration.expanded.fallbackPlacement = .over(scene: windowScene)
            
            (buffer.baseAddress! + index).initialize(to: playerViewController)
        }
        
        initializedCount = buffer.count
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let configuration: UICollectionViewCompositionalLayoutConfiguration = .init()
        configuration.scrollDirection = .horizontal
        
        let collectionViewLayout: UICollectionViewCompositionalLayout = .init(
            sectionProvider: { sectionIndex, environment in
                let itemSize: NSCollectionLayoutSize = .init(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
                
                let item: NSCollectionLayoutItem = .init(layoutSize: itemSize)
                
                let groupSize: NSCollectionLayoutSize = .init(
                    widthDimension: .absolute(200.0),
                    heightDimension: .fractionalHeight(1.0)
                )
                
                let group: NSCollectionLayoutGroup = .vertical(layoutSize: groupSize, repeatingSubitem: item, count: 1)
                
                let section: NSCollectionLayoutSection = .init(group: group)
                
                return section
        }, 
            configuration: configuration
        )
        
        let collectionView: UICollectionView = .init(frame: view.bounds, collectionViewLayout: collectionViewLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        
        self.collectionView = collectionView
        
        let playerViewControllers: [AVPlayerViewController] = playerViewControllers
        
        cellRegistration = .init { cell, indexPath, itemIdentifier in
            var contentConfiguration: UIListContentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = indexPath.description
            cell.contentConfiguration = contentConfiguration
            
            let playerViewController: AVPlayerViewController = playerViewControllers[indexPath.item]
            
            var backgroundConfiguration: UIBackgroundConfiguration = cell.defaultBackgroundConfiguration()
            
            if playerViewController.experienceController.experience == .multiView {
                backgroundConfiguration.backgroundColor = .systemOrange.withAlphaComponent(0.3)
            } else if playerViewController.experienceController.experience == .expanded {
                backgroundConfiguration.backgroundColor = .systemGreen.withAlphaComponent(0.3)
            }
            
            cell.backgroundConfiguration = backgroundConfiguration
        }
        
        for playerViewController in playerViewControllers {
            playerViewController.experienceController.delegate = self
        }
    }
    
    func setup() {
        AVMultiViewManager.default.contentSelectionViewController = self
    }
}

extension MyContentSelectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let playerViewController: AVPlayerViewController = playerViewControllers[indexPath.item]
        
        Task {
            let experienceController: AVExperienceController = playerViewController.experienceController
            
            switch experienceController.experience {
            case .embedded:
                await playerViewController.experienceController.transition(to: .multiView)
            case .multiView:
                await playerViewController.experienceController.transition(to: .expanded)
            case .expanded:
                await playerViewController.experienceController.transition(to: .embedded)
            @unknown default:
                fatalError()
            }
        }
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension MyContentSelectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        playerViewControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: ())
    }
}

extension MyContentSelectionViewController: AVExperienceController.Delegate {
    func experienceController(_ controller: AVExperienceController, prepareForTransitionUsing context: AVExperienceController.TransitionContext) async {
        
    }
    
    func experienceController(_ controller: AVExperienceController, didChangeTransitionContext context: AVExperienceController.TransitionContext) {
        let item: Int = playerViewControllers.firstIndex(where: { Unmanaged.passUnretained($0.experienceController).toOpaque() == Unmanaged.passUnretained(controller).toOpaque() })!
        
        collectionView.performBatchUpdates { 
            collectionView.reconfigureItems(at: [.init(item: item, section: .zero)])
        }
    }
    
    func experienceController(_ controller: AVExperienceController, didChangeAvailableExperiences availableExperiences: AVExperienceController.Experiences) {
        
    }
}
