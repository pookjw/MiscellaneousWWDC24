//
//  CoreDataStackTests.swift
//  MyCanvasDataTests
//
//  Created by Jinwoo Kim on 3/6/25.
//

import Testing
import MyCanvasData.Private
@testable import MyCanvasData

struct CoreDataStackTests {
    @Test("Get Shared Instance") func test_getSharedInstance() {
        _ = CoreDataStack.shared
    }
    
    @Test("Get Background Context") func test_getBackgroundContext() async {
        let context = CoreDataStack.shared.backgroundContext
        let persistentStoreCoordinator = await context.perform { context.persistentStoreCoordinator }
        #expect(persistentStoreCoordinator != nil)
    }
}
