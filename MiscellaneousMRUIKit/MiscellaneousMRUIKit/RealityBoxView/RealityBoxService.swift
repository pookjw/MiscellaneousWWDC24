//
//  RealityBoxService.swift
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 2/10/25.
//

import UIKit
import Observation
import RealityFoundation
import _RealityKit_SwiftUI

@Observable
@MainActor
final class RealityBoxService {
    let rootEntity = Entity()
    private(set) var boundingBox = BoundingBox()
    private let boundingBoxEntity = Entity()
    
    func configureRealityView(content: inout RealityViewContent, boundingBox: BoundingBox) {
        let rootEntity = rootEntity
        
        assert(rootEntity.parent == nil)
        content.add(rootEntity)
        
        assert(boundingBoxEntity.parent == nil)
        content.add(boundingBoxEntity)
        
        RealityBoxService.updateBoundingBoxEntity(boundingBoxEntity, boundingBox: boundingBox)
    }
    
    func updateRealityView(content: inout RealityViewContent, boundingBox: BoundingBox) {
        assert(rootEntity.parent != nil)
        assert(boundingBoxEntity.parent != nil)
        
        RealityBoxService.updateBoundingBoxEntity(boundingBoxEntity, boundingBox: boundingBox)
        self.boundingBox = boundingBox
    }
    
    private static func updateBoundingBoxEntity(_ boxEntity: Entity, boundingBox: BoundingBox) {
        let min: SIMD3<Float> = boundingBox.min
        let max: SIMD3<Float> = boundingBox.max
        let center: SIMD3<Float> = boundingBox.center
        
        for face in Face.allCases {
            let thickness: Float = 1E-3
            let position: SIMD3<Float>
            let size: SIMD3<Float>
            switch face {
            case .lHandFace:
                position = SIMD3<Float>(x: min.x, y: center.y, z: center.z)
                size = SIMD3<Float>(x: thickness, y: boundingBox.extents.y, z: boundingBox.extents.z)
            case .rHandFace:
                position = SIMD3<Float>(x: max.x, y: center.y, z: center.z)
                size = SIMD3<Float>(x: thickness, y: boundingBox.extents.y, z: boundingBox.extents.z)
            case .lowerFace:
                position = SIMD3<Float>(x: center.x, y: min.y, z: center.z)
                size = SIMD3<Float>(x: boundingBox.extents.x, y: thickness, z: boundingBox.extents.z)
            case .upperFace:
                position = SIMD3<Float>(x: center.x, y: max.y, z: center.z)
                size = SIMD3<Float>(x: boundingBox.extents.x, y: thickness, z: boundingBox.extents.z)
            case .nearFace:
                position = SIMD3<Float>(x: center.x, y: center.y, z: min.z)
                size = SIMD3<Float>(x: boundingBox.extents.x, y: boundingBox.extents.y, z: thickness)
            case .afarFace:
                position = SIMD3<Float>(x: center.x, y: center.y, z: max.z)
                size = SIMD3<Float>(x: boundingBox.extents.x, y: boundingBox.extents.y, z: thickness)
            }
            
            let boxShape = ShapeResource.generateBox(size: size)
            
            let faceEntity: ModelEntity
            var collisionComponent: CollisionComponent
            var physicsBodyComponent: PhysicsBodyComponent
            var modelComponent: ModelComponent
            
            if let _faceEntity = boxEntity.findEntity(named: face.rawValue) {
                faceEntity = _faceEntity as! ModelEntity
                
                collisionComponent = faceEntity.components[CollisionComponent.self]!
                collisionComponent.shapes = [boxShape]
                
                physicsBodyComponent = faceEntity.components[PhysicsBodyComponent.self]!
                physicsBodyComponent.massProperties = PhysicsMassProperties(shape: boxShape, mass: physicsBodyComponent.massProperties.mass)
                
                modelComponent = faceEntity.components[ModelComponent.self]!
                modelComponent.mesh = MeshResource.generateBox(size: size)
            } else {
                faceEntity = ModelEntity()
                faceEntity.name = face.rawValue
                
                collisionComponent = CollisionComponent(
                    shapes: [boxShape],
                    mode: .colliding,
                    filter: .init(group: .default, mask: .default)
                )
                
                physicsBodyComponent = PhysicsBodyComponent(
                    shapes: [boxShape],
                    mass: 1.0,
                    material: nil,
                    mode: .static // 벽은 움직이지 않는다.
                )
                physicsBodyComponent.isAffectedByGravity = false
                
                modelComponent = ModelComponent(
                    mesh: MeshResource.generateBox(size: size),
                    materials: [
                        SimpleMaterial(color: UIColor.cyan.withAlphaComponent(0.75), isMetallic: true)
                    ]
                )
                
                boxEntity.addChild(faceEntity)
            }
            
            faceEntity.components.set(collisionComponent)
            faceEntity.components.set(physicsBodyComponent)
            
            faceEntity.position = position
//            faceEntity.model = modelComponent
            faceEntity.components.set(modelComponent)
        }
    }
}
