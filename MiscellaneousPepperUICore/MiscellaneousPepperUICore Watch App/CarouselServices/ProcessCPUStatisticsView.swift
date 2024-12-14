//
//  ProcessCPUStatisticsView.swift
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 12/14/24.
//

import SwiftUI
import Charts
@preconcurrency import ObjectiveC.message

@_expose(Cxx)
public nonisolated func makeProcessCPUStatisticsHostingController() -> NSObject {
    return MainActor.assumeIsolated {
        let hostingController: (any NSObject & _UIHostingViewable) = _makeUIHostingController(
            AnyView(
                ProcessCPUStatisticsView()
            ),
            tracksContentSize: true
        )
        
        return hostingController
    }
}

struct ProcessCPUStatisticsView: View {
    @State private var viewModel = ViewModel()
    
    var body: some View {
        Group {
            if let snapshot = viewModel.snapshot {
                ScrollView { 
                    VStack {
                        Chart(Array(viewModel.busyPercents.enumerated()), id: \.offset) { data in
                            AreaMark(
                                x: .value("Index", data.offset),
                                y: .value("Percent", data.element)
                            )
                        }
                        .chartYAxis { 
                            AxisMarks(
                                format: Decimal.FormatStyle.Percent.percent.scale(1),
                                values: [0, 100]
                            )
                        }
                        .chartXAxis(.hidden)
                        
                        Group {
                            Text("totalElapsedTime: \(CSLProcessCPUStatisticsSnapshot_totalElapsedTime(snapshot: snapshot))")
                            Text("totalElapsedUserTime: \(CSLProcessCPUStatisticsSnapshot_totalElapsedUserTime(snapshot: snapshot))")
                            Text("totalElapsedSystemTime: \(CSLProcessCPUStatisticsSnapshot_totalElapsedSystemTime(snapshot: snapshot))")
                            Text("totalElapsedIdleTime: \(CSLProcessCPUStatisticsSnapshot_totalElapsedIdleTime(snapshot: snapshot))")
                            Text("applicationCPUTime: \(CSLProcessCPUStatisticsSnapshot_applicationCPUTime(snapshot: snapshot))")
                        }
                        .lineLimit(1)
                        .minimumScaleFactor(0.001)
                    }
                }
            } else {
                ProgressView()
            }
        }
        .toolbar { 
            ToolbarItem(placement: .topBarTrailing) { 
                Button { 
                    if viewModel.isStarted {
                        viewModel.stop()
                    } else {
                        viewModel.start()
                    }
                } label: { 
                    Image(systemName: viewModel.isStarted ? "pause.fill" : "play.fill")
                }

            }
        }
        .onAppear { 
            viewModel.start()
        }
        .onDisappear {
            viewModel.stop()
        }
    }
}

extension ProcessCPUStatisticsView {
    @Observable @MainActor
    final class ViewModel: NSObject {
        private let processCPUStatistics = CSLSProcessCPUStatistics_initWithProcessHandle(processHandle: RBSProcessHandle_currentProcess())
        private(set) var snapshot: AnyObject?
        private(set) var busyPercents: [CInt] = .init(repeating: .zero, count: 30)
        private var timer: Timer?
        
        var isStarted: Bool {
            guard let timer else { return false }
            return timer.isValid
        }
        
        deinit {
            _timer?.invalidate()
        }
        
        func start() {
            if timer != nil {
                stop()
            }
            
            timer = .scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(didTriggerTimer(_:)), userInfo: nil, repeats: true)
        }
        
        func stop() {
            guard let timer else { return }
            timer.invalidate()
            self.timer = nil
        }
        
        @objc private func didTriggerTimer(_ sender: Timer) {
            MainActor.assumeIsolated { 
                let snapshot = CSLSProcessCPUStatistics_snapshot(processCPUStatistics: processCPUStatistics)
                self.snapshot = snapshot
                
                withAnimation {
                    busyPercents.removeFirst()
                    busyPercents.append(CSLProcessCPUStatisticsSnapshot_busyPercent(snapshot: snapshot))
                }
            }
        }
    }
}

fileprivate func CSLSProcessCPUStatistics_initWithProcessHandle(processHandle: AnyObject) -> AnyObject {
    let CSLSProcessCPUStatistics: AnyClass = objc_lookUpClass("CSLSProcessCPUStatistics")!
    let _cmd = Selector(("initWithProcessHandle:"))
    let method = class_getInstanceMethod(CSLSProcessCPUStatistics, _cmd)!
    let imp = method_getImplementation(method)
    let casted = unsafeBitCast(imp, to: (@convention(c) (AnyObject, Selector, AnyObject) -> AnyObject).self)
    
    return casted(CSLSProcessCPUStatistics.alloc(), _cmd, processHandle)
}

fileprivate func RBSProcessHandle_currentProcess() -> AnyObject {
    let RBSProcessHandle: AnyClass = objc_lookUpClass("RBSProcessHandle")!
    let _cmd = Selector(("currentProcess"))
    let method = class_getClassMethod(RBSProcessHandle, _cmd)!
    let imp = method_getImplementation(method)
    let casted = unsafeBitCast(imp, to: (@convention(c) (AnyClass, Selector) -> AnyObject).self)
    
    return casted(RBSProcessHandle, _cmd)
}

fileprivate func CSLSProcessCPUStatistics_snapshot(processCPUStatistics: AnyObject) -> AnyObject {
    let CSLSProcessCPUStatistics: AnyClass = objc_lookUpClass("CSLSProcessCPUStatistics")!
    let _cmd = Selector(("snapshot"))
    let method = class_getInstanceMethod(CSLSProcessCPUStatistics, _cmd)!
    let imp = method_getImplementation(method)
    let casted = unsafeBitCast(imp, to: (@convention(c) (AnyObject, Selector) -> AnyObject).self)
    
    return casted(processCPUStatistics, _cmd)
}

fileprivate func CSLProcessCPUStatisticsSnapshot_totalElapsedTime(snapshot: AnyObject) -> Double {
    let CSLProcessCPUStatisticsSnapshot: AnyClass = objc_lookUpClass("CSLProcessCPUStatisticsSnapshot")!
    let _cmd = Selector(("totalElapsedTime"))
    let method = class_getInstanceMethod(CSLProcessCPUStatisticsSnapshot, _cmd)!
    let imp = method_getImplementation(method)
    let casted = unsafeBitCast(imp, to: (@convention(c) (AnyObject, Selector) -> Double).self)
    
    return casted(snapshot, _cmd)
}

fileprivate func CSLProcessCPUStatisticsSnapshot_totalElapsedUserTime(snapshot: AnyObject) -> Double {
    let CSLProcessCPUStatisticsSnapshot: AnyClass = objc_lookUpClass("CSLProcessCPUStatisticsSnapshot")!
    let _cmd = Selector(("totalElapsedUserTime"))
    let method = class_getInstanceMethod(CSLProcessCPUStatisticsSnapshot, _cmd)!
    let imp = method_getImplementation(method)
    let casted = unsafeBitCast(imp, to: (@convention(c) (AnyObject, Selector) -> Double).self)
    
    return casted(snapshot, _cmd)
}

fileprivate func CSLProcessCPUStatisticsSnapshot_totalElapsedSystemTime(snapshot: AnyObject) -> Double {
    let CSLProcessCPUStatisticsSnapshot: AnyClass = objc_lookUpClass("CSLProcessCPUStatisticsSnapshot")!
    let _cmd = Selector(("totalElapsedSystemTime"))
    let method = class_getInstanceMethod(CSLProcessCPUStatisticsSnapshot, _cmd)!
    let imp = method_getImplementation(method)
    let casted = unsafeBitCast(imp, to: (@convention(c) (AnyObject, Selector) -> Double).self)
    
    return casted(snapshot, _cmd)
}

fileprivate func CSLProcessCPUStatisticsSnapshot_totalElapsedIdleTime(snapshot: AnyObject) -> Double {
    let CSLProcessCPUStatisticsSnapshot: AnyClass = objc_lookUpClass("CSLProcessCPUStatisticsSnapshot")!
    let _cmd = Selector(("totalElapsedIdleTime"))
    let method = class_getInstanceMethod(CSLProcessCPUStatisticsSnapshot, _cmd)!
    let imp = method_getImplementation(method)
    let casted = unsafeBitCast(imp, to: (@convention(c) (AnyObject, Selector) -> Double).self)
    
    return casted(snapshot, _cmd)
}

fileprivate func CSLProcessCPUStatisticsSnapshot_applicationCPUTime(snapshot: AnyObject) -> Double {
    let CSLProcessCPUStatisticsSnapshot: AnyClass = objc_lookUpClass("CSLProcessCPUStatisticsSnapshot")!
    let _cmd = Selector(("applicationCPUTime"))
    let method = class_getInstanceMethod(CSLProcessCPUStatisticsSnapshot, _cmd)!
    let imp = method_getImplementation(method)
    let casted = unsafeBitCast(imp, to: (@convention(c) (AnyObject, Selector) -> Double).self)
    
    return casted(snapshot, _cmd)
}

fileprivate func CSLProcessCPUStatisticsSnapshot_busyPercent(snapshot: AnyObject) -> CInt {
    let CSLProcessCPUStatisticsSnapshot: AnyClass = objc_lookUpClass("CSLProcessCPUStatisticsSnapshot")!
    let _cmd = Selector(("busyPercent"))
    let method = class_getInstanceMethod(CSLProcessCPUStatisticsSnapshot, _cmd)!
    let imp = method_getImplementation(method)
    let casted = unsafeBitCast(imp, to: (@convention(c) (AnyObject, Selector) -> CInt).self)
    
    return casted(snapshot, _cmd)
}

extension Timer: @retroactive @unchecked Sendable {}
