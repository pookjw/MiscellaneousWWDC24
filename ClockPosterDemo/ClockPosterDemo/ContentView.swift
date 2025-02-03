//
//  ContentView.swift
//  ClockPosterDemo
//
//  Created by Jinwoo Kim on 2/3/25.
//

import SwiftUI
import ClockPoster

struct ContentView: View {
    @State private var isDisplayStyleRedMode = false
    
    @State private var playLooks: [ClockFaceLookWrapper] = []
    @State private var selectedPlayLook: ClockFaceLook?
    
    @State private var solorLooks: [ClockFaceLookWrapper] = []
    @State private var selectedSolarLook: ClockFaceLook?
    
    @State private var worldLooks: [ClockFaceLookWrapper] = []
    @State private var selectedWorldLook: ClockFaceLook?
    
    @State private var analogLooks: [ClockFaceLookWrapper] = []
    @State private var selectedAnalogLook: ClockFaceLook?
    
    @State private var digitalLooks: [ClockFaceLookWrapper] = []
    @State private var selectedDigitalLook: ClockFaceLook?
    
    @State private var selectedFace = ClockFaceKind.play.rawValue
    @State private var showEditor = false
    
    var body: some View {
        TabView(selection: $selectedFace) {
            ClockFaceView
                .playFace(
                    suggestedLooksHandler: { playLooks in
                        self.playLooks = playLooks.map { ClockFaceLookWrapper(look: $0 )}
                    }
                )
                .redMode(isDisplayStyleRedMode)
                .look(selectedPlayLook)
                .tag(ClockFaceKind.play.rawValue)
                .ignoresSafeArea()
            
            ClockFaceView
                .solarFace(
                    suggestedLooksHandler: { solorLooks in
                        self.solorLooks = solorLooks.map { ClockFaceLookWrapper(look: $0 )}
                    }
                )
                .redMode(isDisplayStyleRedMode)
                .look(selectedSolarLook)
                .tag(ClockFaceKind.solar.rawValue)
                .ignoresSafeArea()
            
            ClockFaceView
                .worldFace(
                    suggestedLooksHandler: { worldLooks in
                        self.worldLooks = worldLooks.map { ClockFaceLookWrapper(look: $0 )}
                    }
                )
                .redMode(isDisplayStyleRedMode)
                .look(selectedWorldLook)
                .tag(ClockFaceKind.world.rawValue)
                .ignoresSafeArea()
            
            ClockFaceView
                .analogFace(
                    suggestedLooksHandler: { analogLooks in
                        self.analogLooks = analogLooks.map { ClockFaceLookWrapper(look: $0 )}
                    }
                )
                .redMode(isDisplayStyleRedMode)
                .look(selectedAnalogLook)
                .tag(ClockFaceKind.analog.rawValue)
                .ignoresSafeArea()
            
            ClockFaceView
                .digitalFace(
                    suggestedLooksHandler: { digitalLooks in
                        self.digitalLooks = digitalLooks.map { ClockFaceLookWrapper(look: $0 )}
                    }
                )
                .redMode(isDisplayStyleRedMode)
                .look(selectedDigitalLook)
                .tag(ClockFaceKind.digital.rawValue)
                .ignoresSafeArea()
        }
        .tabViewStyle(.page)
        .background(Color.black)
        .onTapGesture(count: 2) {
            withAnimation { 
                showEditor.toggle()
            }
        }
        .ignoresSafeArea()
        .overlay(alignment: .bottom) {
            if showEditor {
                VStack {
                    ScrollView(.horizontal) { 
                        HStack {
                            ForEach(looksForCurrentPage) { look in
                                look.thumbnailSwiftUIView
                                    .frame(width: 80, height: 80)
                                    .onTapGesture { 
                                        didSelectLook(look)
                                    }
                            }
                        }
                        .padding(10)
                    }
                    .scrollIndicators(.hidden)
                    .frame(height: 100)
                    
                    Toggle("Red Mode", isOn: $isDisplayStyleRedMode)
                        .foregroundStyle(Color.red)
                        .padding([.leading, .trailing, .bottom])
                }
                .background(.ultraThinMaterial)
            }
        }
    }
    
    private var looksForCurrentPage: [ClockFaceLookWrapper] {
        switch selectedFace {
        case ClockFaceKind.play.rawValue:
            return playLooks
        case ClockFaceKind.solar.rawValue:
            return solorLooks
        case ClockFaceKind.world.rawValue:
            return worldLooks
        case ClockFaceKind.analog.rawValue:
            return analogLooks
        case ClockFaceKind.digital.rawValue:
            return digitalLooks
        default:
            fatalError()
        }
    }
    
    private func didSelectLook(_ wrapper: ClockFaceLookWrapper) {
        switch selectedFace {
        case ClockFaceKind.play.rawValue:
            selectedPlayLook = wrapper.look
        case ClockFaceKind.solar.rawValue:
            selectedSolarLook = wrapper.look
        case ClockFaceKind.world.rawValue:
            selectedWorldLook = wrapper.look
        case ClockFaceKind.analog.rawValue:
            selectedAnalogLook = wrapper.look
        case ClockFaceKind.digital.rawValue:
            selectedDigitalLook = wrapper.look
        default:
            fatalError()
        }
    }
}

fileprivate struct ClockFaceLookWrapper: Identifiable {
    let look: ClockFaceLook
    var id: String { String(describing: look) }
    
    @MainActor var thumbnailSwiftUIView: some View {
        ThumbnailSwiftUIView(look: look)
    }
    
    private struct ThumbnailSwiftUIView: UIViewRepresentable {
        let look: ClockFaceLook
        
        func makeUIView(context: Context) -> UIView {
            look.thumbnailView
        }
        
        func updateUIView(_ uiView: UIView, context: Context) {
            
        }
    }
}

#Preview {
    ContentView()
}
