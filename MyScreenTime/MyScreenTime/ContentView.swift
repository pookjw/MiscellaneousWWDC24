//
//  ContentView.swift
//  MyScreenTime
//
//  Created by Jinwoo Kim on 4/22/25.
//

import SwiftUI
import Combine
import FamilyControls
import ManagedSettings
import DeviceActivity
import ManagedSettingsPrivate

struct ContentView: View {
    @State private var authorizationStatus: FamilyControls.AuthorizationStatus?
    @State private var selection: FamilyControls.FamilyActivitySelection = {
        if let data = UserDefaults.standard.data(forKey: "selection") {
            let decoder = JSONDecoder()
            let decoded = try! decoder.decode(FamilyControls.FamilyActivitySelection.self, from: data)
            return decoded
        } else {
            return .init(includeEntireCategory: true)
        }
    }()
    @State private var isPresented: Bool = false
    @State private var store: ManagedSettings.ManagedSettingsStore = ManagedSettings.ManagedSettingsStore(named: .init("Test"))
    @State private var center: DeviceActivity.DeviceActivityCenter = .init()
    
    var body: some View {
        Form {
            Section("Categories") { 
                ForEach(Array(selection.categories), id: \.hashValue) { category in
                    VStack(alignment: .leading) { 
                        Text(category.localizedDisplayName ?? "(nil)")
                        
                        if let token: ManagedSettings.Token<ActivityCategory> = category.token {
                            Text(String(describing: token))
                        }
                    }
                }
            }
            
            Section("Category Tokens") { 
                ForEach(Array(selection.categoryTokens), id: \.hashValue) { categoryToken in
                    Text(String(describing: categoryToken))
                }
            }
            
            Section("Applications") { 
                ForEach(Array(selection.applications), id: \.hashValue) { application in
                    if let bundleIdentifier: String = application.bundleIdentifier {
                        Text(bundleIdentifier)
                    }
                    
                    if let token: ManagedSettings.ApplicationToken = application.token {
                        Text(String(describing: token))
                    }
                    
                    if let localizedDisplayName = application.localizedDisplayName {
                        Text(localizedDisplayName)
                    }
                }
            }
            
            Section("Application Tokens") { 
                ForEach(Array(selection.applicationTokens), id: \.hashValue) { applicationToken in
                    Text(String(describing: applicationToken))
                }
            }
            
            Section("Web Domains") { 
                ForEach(Array(selection.webDomains), id: \.hashValue) { webDomain in
                    if let domain: String = webDomain.domain {
                        Text(domain)
                    }
                    
                    if let token: ManagedSettings.WebDomainToken = webDomain.token {
                        Text(String(describing: token))
                    }
                }
            }
            
            Section("Web Domain Tokens") { 
                ForEach(Array(selection.webDomainTokens), id: \.hashValue) { webDomainToken in
                    Text(String(describing: webDomainToken))
                }
            }
        }
        .toolbar { 
            Menu { 
                switch authorizationStatus {
                case .notDetermined:
                    Button("Request Authorization") { 
                        Task {
                            try! await FamilyControls.AuthorizationCenter.shared.requestAuthorization(for: .individual)
                        }
                    }
                case .denied:
                    Text("Denined")
                case .approved:
                    Text("Approved")
                case nil:
                    Text("Pending")
                case .some(_):
                    fatalError()
                }
                
                NavigationLink { 
                    FamilyControls.FamilyActivityPicker(headerText: "Header Text", footerText: "Footer Text", selection: $selection)
                } label: { 
                    Text("Push Activity Picker")
                }
                
                Button("Present Activity Picker") { 
                    isPresented = true
                }
                
                Button("Sync Store") {
                    var intelligence = store.getIntelligence()
                    intelligence.denyImagePlayground = true
                    print(intelligence.denyImagePlayground)
                    
                    store.setIntelligence(intelligence)
                    
                    print(store.getIntelligence().denyImagePlayground)
                    
                    store.shield.applications = selection.applicationTokens
                }
                
                Button("Start Monitoring") {
                    let now = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: .now)
                    
                    var start = now
//                    start.minute! += 3
                    
                    var end = now
                    end.hour! += 1
                    
//                    var warningTime = now
//                    warningTime.minute! += 5
                    
                    var threshold = now
                    threshold.minute! = 50
                    
                    let schedule = DeviceActivitySchedule.init(intervalStart: start, intervalEnd: end, repeats: true, warningTime: nil)
                    
//                    let formatter = DateFormatter()
//                    formatter.dateFormat = "MM-dd-yyyy HH:mm"
//                    formatter.locale = .current
//                    print(formatter.string(from: schedule.nextInterval!.start), formatter.string(from: schedule.nextInterval!.end))
                    
                    try! center
                        .startMonitoring(
                            .init("Test"),
                            during: schedule
                            ,
                            events: [.init("Name"): .init(applications: selection.applicationTokens, categories: selection.categoryTokens, webDomains: selection.webDomainTokens, threshold: threshold)]
                        )
                }
                
                Menu("Stop Monitoring") {
                    // reload 필요함
                    ForEach(center.activities, id: \.rawValue) { activity in
                        Button(activity.rawValue) {
                            center.stopMonitoring([activity])
                        }
                    }
                }
                
                Menu {
                    Button("includeEntireCategory = true") {
                        selection = .init(includeEntireCategory: true)
                    }
                    
                    Button("includeEntireCategory = false") {
                        selection = .init(includeEntireCategory: false)
                    }
                } label: { 
                    Text("Reset Selections")
                }
            } label: { 
                Label("Menu", systemImage: "filemenu.and.selection")
            }
        }
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
        .familyActivityPicker(headerText: "Header Text", footerText: "Footer Text", isPresented: $isPresented, selection: $selection)
        .onReceive(FamilyControls.AuthorizationCenter.shared.$authorizationStatus) { newValue in
            authorizationStatus = newValue
        }
        .onChange(of: selection, initial: true) { oldValue, newValue in
            let encoder = JSONEncoder()
            let data = try! encoder.encode(newValue)
            UserDefaults.standard.set(data, forKey: "selection")
        }
    }
}

#Preview {
    ContentView()
}
