//
//  CameraCaptureEventView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 7/6/24.
//

#if os(iOS)

import SwiftUI
import AVKit

struct CameraCaptureEventView: View {
    @State private var flag = false
    
    var body: some View {
//        Button("Camera") {
//            flag = true
//        }
////        .sheet(isPresented: $flag, content: { 
////            ImagePickerView()
////        })

        TestView()
            .onCameraCaptureEvent(primaryAction: { event in
                print(event)
            }, secondaryAction: { event in
                print(event)
            })
    }
}

fileprivate struct TestView: UIViewRepresentable {
    func makeUIView(context: Context) -> ContentView {
        .init(frame: .null)
    }
    
    func updateUIView(_ uiView: ContentView, context: Context) {
        
    }
    
    typealias UIViewType = ContentView
    
    final class ContentView: UIView {
        private let captureSession: AVCaptureSession = .init()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            guard let camera = AVCaptureDevice.default(for: .video) else {
                print("Unable to access the camera.")
                return
            }
            
            let input = try! AVCaptureDeviceInput(device: camera)
            captureSession.addInput(input)
            
            var videoPreviewLayer: AVCaptureVideoPreviewLayer!
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer.videoGravity = .resizeAspect
            videoPreviewLayer.frame = layer.bounds
            layer.addSublayer(videoPreviewLayer)
            
            captureSession.startRunning()
            
            let interaction: AVCaptureEventInteraction = .init { event in
                print(event)
            } secondary: { event in
                print(event)
            }

            addInteraction(interaction)
        }
        
        deinit {
            captureSession.stopRunning()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

fileprivate struct ImagePickerView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePickerController: UIImagePickerController = .init()
        imagePickerController.sourceType = .camera
        imagePickerController.delegate = context.coordinator
        return imagePickerController
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        .init()
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
        }
    }
    
}

#Preview {
    CameraCaptureEventView()
}

#endif
