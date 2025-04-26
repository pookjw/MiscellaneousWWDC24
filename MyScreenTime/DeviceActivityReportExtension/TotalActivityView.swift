//
//  TotalActivityView.swift
//  DeviceActivityReportExtension
//
//  Created by Jinwoo Kim on 4/25/25.
//

import SwiftUI
import DeviceActivity
import ManagedSettings
import FamilyControls

@_silgen_name("swift_EnumCaseName")
func _getEnumCaseName<T>(_ value: T) -> UnsafePointer<CChar>?

extension DeviceActivityData.User.FamilyRole {
    fileprivate var string: String {
        let cString = _getEnumCaseName(self)!
        let caseName = String(validatingCString: cString)!
        return caseName
    }
}
extension DeviceActivityData.Device.Model {
    fileprivate var string: String {
        let cString = _getEnumCaseName(self)!
        let caseName = String(validatingCString: cString)!
        return caseName
    }
}

struct TotalActivityView: View {
    let results: [DeviceActivityData]
    @State private var activitySegments: [DeviceActivityData.ActivitySegment] = []
    
    var body: some View {
        NavigationStack {
            List(results, id: \.hashValue) { result in
                Section { 
                    if let appleID = result.user.appleID {
                        LabeledContent("Apple ID") { Text(appleID) }
                    }
                    if let nameComponents = result.user.nameComponents {
                        LabeledContent("Name Components") { Text(String(describing: nameComponents)) }
                    }
                    
                    if let name = result.device.name {
                        LabeledContent("Device Name") { Text(name) }
                    }
                    
                    LabeledContent("Device Model") { Text(result.device.model.string) }
                    LabeledContent("Role") { Text(result.user.role.string) }
                    LabeledContent("lastUpdatedDate") { Text(String(describing: result.lastUpdatedDate)) }
                    LabeledContent("segmentInterval") { Text(String(describing: result.segmentInterval)) }
                    
                    ForEach(activitySegments, id: \.hashValue) { segment in
                        NavigationLink(String(describing: segment.hashValue)) {
                            ActivitySegmentView(activitySegment: segment)
                        }
                    }
                }
            }
        }
        .ignoresSafeArea()
        .task {
            var activitySegments: [DeviceActivityData.ActivitySegment] = []
            for result in results {
                for await segment in result.activitySegments {
                    activitySegments.append(segment)
                }
            }
            self.activitySegments = activitySegments
        }
    }
}

extension TotalActivityView {
    fileprivate struct ActivitySegmentView: View {
        let activitySegment: DeviceActivityData.ActivitySegment
        @State private var categories: [DeviceActivityData.CategoryActivity] = []
        
        var body: some View {
            List { 
                ForEach(categories, id: \.hashValue) { category in
                    NavigationLink(category.category.localizedDisplayName ?? "(nil)") { 
                        ActicityCategoryView(category: category)
                    }
                }
                
                LabeledContent("dateInterval") { Text(String(describing: activitySegment.dateInterval)) }
                
                if let firstPickup = activitySegment.firstPickup {
                    LabeledContent("firstPickup") { Text(String(describing: firstPickup)) }
                }
                if let longestActivity = activitySegment.longestActivity {
                    LabeledContent("longestActivity") { Text(String(describing: longestActivity)) }
                }
                LabeledContent("totalActivityDuration") { Text(String(describing: activitySegment.totalActivityDuration)) }
                LabeledContent("totalPickupsWithoutApplicationActivity") { Text(String(describing: activitySegment.totalPickupsWithoutApplicationActivity)) }
            }
            .task {
                var categories: [DeviceActivityData.CategoryActivity] = []
                for await category in activitySegment.categories {
                    categories.append(category)
                }
                self.categories = categories
            }
        }
    }
    
    fileprivate struct ActicityCategoryView: View {
        let category: DeviceActivityData.CategoryActivity
        @State private var applications: [DeviceActivityData.ApplicationActivity] = []
        @State private var webDomains: [DeviceActivityData.WebDomainActivity] = []
        
        var body: some View {
            List { 
                if let localizedDisplayName = category.category.localizedDisplayName {
                    LabeledContent("localizedDisplayName") { Text(localizedDisplayName) }
                }
                if let token = category.category.token {
                    LabeledContent("token") { Text(String(describing: token)) }
                }
                
                LabeledContent("totalActivityDuration") { 
                    Text(String(describing: category.totalActivityDuration))
                }
                
                Section { 
                    ForEach(applications, id: \.hashValue) { application in
                        NavigationLink(application.application.localizedDisplayName ?? application.application.bundleIdentifier ?? "(nil)") { 
                            ApplicationView(application: application)
                        }
                    }
                }
            }
            .task {
                var applications: [DeviceActivityData.ApplicationActivity] = []
                for await application in category.applications {
                    applications.append(application)
                }
                self.applications = applications
                
                var webDomains: [DeviceActivityData.WebDomainActivity] = []
                for await webDomain in category.webDomains {
                    webDomains.append(webDomain)
                }
                self.webDomains = webDomains
            }
        }
    }
    
    fileprivate struct ApplicationView: View {
        let application: DeviceActivityData.ApplicationActivity
        
        var body: some View {
            List {
                Section {
                    LabeledContent("numberOfNotifications") { Text(String(describing: application.numberOfNotifications)) }
                    LabeledContent("numberOfPickups") { Text(String(describing: application.numberOfPickups)) }
                    LabeledContent("totalActivityDuration") { Text(String(describing: application.totalActivityDuration)) }
                }
                
                if let bundleIdentifier = application.application.bundleIdentifier {
                    LabeledContent("bundleIdentifier") { Text(bundleIdentifier) }
                }
                
                if let token = application.application.token {
                    LabeledContent("token") { Text(String(describing: token)) }
                }
                
                if let localizedDisplayName = application.application.localizedDisplayName {
                    LabeledContent("localizedDisplayName") { Text(localizedDisplayName) }
                }
                
                if let token = application.application.token {
                    Label.init(token)
                    Label.init(token)
                }
            }
        }
    }
}
