//
//  DeviceActivityReportExtensionObjC.swift
//  DeviceActivityReportExtensionObjC
//
//  Created by Jinwoo Kim on 4/25/25.
//

#if swift(>=6)
#error("ExtensionKit does not support Swift 6")
#else

import SwiftUI
import ExtensionKit

@main
@MainActor
struct DeviceActivityReportExtensionObjC: AppExtension {
    let configuration = AppExtensionSceneConfiguration(ExtensionScene())
}

struct ExtensionScene: AppExtensionScene {
    var body: some AppExtensionScene {
        TotalActivityExtensionScene()
    }
}

struct TotalActivityExtensionScene: AppExtensionScene {
    private let key = UUID()
    
    var body: some AppExtensionScene {
        PrimitiveAppExtensionScene(id: "Total Activity") {
            runOnMain { 
                CustomView(key: key)
            }
        } onConnection: { connection in
            Connections.shared.mutate { table in
                table.setObject(connection, forKey: key as NSUUID)
            }
            
            connection.remoteObjectInterface = NSXPCInterface(with: NSProtocolFromString("_TtP23_DeviceActivity_SwiftUI30DeviceActivityReportServiceXPC_")!)
            connection.resume()
            return true
        }
    }
}

struct CustomView: UIViewControllerRepresentable {
    let key: UUID
    
    func makeUIViewController(context: Context) -> ViewController {
        let viewController = ViewController()
        viewController.connection = Connections.shared.table.object(forKey: key as NSUUID)
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        uiViewController.connection = Connections.shared.table.object(forKey: key as NSUUID)
    }
}

final class Connections: Observable, @unchecked Sendable {
    static let shared = Connections()
    
    func mutate(_ block: (@Sendable (_ table: NSMapTable<NSUUID, NSXPCConnection>) -> Void)) {
        runOnMain {
            withMutation(keyPath: \._table) {
                block(_table)
            }
        }
    }
    
    private nonisolated(unsafe) var _table: NSMapTable<NSUUID, NSXPCConnection> = .strongToWeakObjects()
    nonisolated var table: NSMapTable<NSUUID, NSXPCConnection> {
        @storageRestrictions(initializes: _table)
        init(initialValue) {
            _table = initialValue
        }
        get {
            access(keyPath: \.table)
            return _table
        }
    }
    
    private init() {}
    
    @ObservationIgnored private let _$observationRegistrar = Observation.ObservationRegistrar()
    
    internal nonisolated func access<Member>(
        keyPath: KeyPath<Connections, Member>
    ) {
        _$observationRegistrar.access(self, keyPath: keyPath)
    }
    
    internal nonisolated func withMutation<Member, MutationResult>(
        keyPath: KeyPath<Connections, Member>,
        _ mutation: () throws -> MutationResult
    ) rethrows -> MutationResult {
        try _$observationRegistrar.withMutation(of: self, keyPath: keyPath, mutation)
    }
}

extension NSXPCConnection: @retroactive @unchecked Sendable {}

func runOnMain<T>(_ block: () -> T) -> T {
    if Thread.isMainThread {
        return block()
    } else {
        return DispatchQueue.main.sync(execute: block)
    }
}

#endif
