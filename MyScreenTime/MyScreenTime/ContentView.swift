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
    @State private var isReportPresented: Bool = false
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
                        Label.init(token)
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
                    // com.apple.private.managed-settings.apply
                    syncStore()
                }
                
                Button("Start Monitoring") {
                    let start = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: .now)
                    let end = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: .now.addingTimeInterval(40 * 60))
                    let threshold = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: .now.addingTimeInterval(50 * 60))
                    
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
                
                Button("Test") {
                    test()
                }
                
                Button("Present Report") {
                    isReportPresented = true
                }
            } label: {
                Label("Menu", systemImage: "filemenu.and.selection")
            }
        }
        .onAppear(perform: { 
            isReportPresented = true
        })
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
        .familyActivityPicker(headerText: "Header Text", footerText: "Footer Text", isPresented: $isPresented, selection: $selection)
        .sheet(isPresented: $isReportPresented) {
            DeviceActivityReport(
                .init("Total Activity"),
                filter: DeviceActivityFilter(
//                    segment: DeviceActivityFilter.SegmentInterval.hourly(during: DateInterval(start: Date.now.addingTimeInterval(-60*60), end: .now)),
                    segment: .weekly(during: DateInterval(start: .distantPast, end: .distantFuture)),
                    users: DeviceActivityFilter.Users.all,
//                    devices: DeviceActivityFilter.Devices.init([DeviceActivityData.Device.Model.iPhone, DeviceActivityData.Device.Model.iPad, DeviceActivityData.Device.Model.iPod, DeviceActivityData.Device.Model.mac]),
                    devices: .all,
                    applications: selection.applicationTokens,
                    categories: selection.categoryTokens,
                    webDomains: selection.webDomainTokens
                )
            )
        }
        .onReceive(FamilyControls.AuthorizationCenter.shared.$authorizationStatus) { newValue in
            authorizationStatus = newValue
        }
        .onChange(of: selection, initial: true) { oldValue, newValue in
            let encoder = JSONEncoder()
            let data = try! encoder.encode(newValue)
            UserDefaults.standard.set(data, forKey: "selection")
        }
    }
    
    private func test() {
        let center = DeviceActivityCenter()
        print(center.activities)
        print(center.events(for: .init("Test")))
    }
    
    private func syncStore() {
        //                    var intelligence = store.getIntelligence()
        //                    intelligence.denyImagePlayground = true
        //                    print(intelligence.denyImagePlayground)
        //                    
        //                    store.setIntelligence(intelligence)
        //                    
        //                    print(store.getIntelligence().denyImagePlayground)
//        var calculator = store.getCalculator()
//        calculator.denyInputModeRPN = true
//        assert(calculator.denyInputModeRPN == true)
//        calculator.denyInputModeUnitConversion = true
//        assert(calculator.denyInputModeUnitConversion == true)
//        calculator.denyMathPaperSolving = true
//        assert(calculator.denyMathPaperSolving == true)
//        calculator.denyModeMathPaper = true
//        assert(calculator.denyModeMathPaper == true)
//        calculator.denyModeProgrammer = true
//        assert(calculator.denyModeProgrammer == true)
//        calculator.denyModeScientific = true
//        assert(calculator.denyModeScientific == true)
//        calculator.forceSquareRootOnBasicCalculator = true
//        assert(calculator.forceSquareRootOnBasicCalculator == true)
//        store.set(calculator)
        
//        store.passcode.lockPasscode = true
//        store.safari.cookiePolicy = .never
//        store.webContent.blockedByFilter = WebContentSettings.FilterPolicy.none
        
        store.shield.applications = selection.applicationTokens
    }
}

#Preview {
    ContentView()
}
