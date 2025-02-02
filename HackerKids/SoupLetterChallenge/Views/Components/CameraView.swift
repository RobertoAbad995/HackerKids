//
//  CameraView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 2/2/25.
//

import AVFoundation
import PhotosUI
import SwiftUI

//// MARK: - Camera View
//struct CameraView: UIViewControllerRepresentable {
//    @ObservedObject var cameraManager: CameraManager
//    
//    func makeUIViewController(context: Context) -> UIViewController {
//        let controller = UIViewController()
//        let previewLayer = AVCaptureVideoPreviewLayer(session: cameraManager.session!)
//        previewLayer.videoGravity = .resizeAspectFill
//        previewLayer.frame = UIScreen.main.bounds
//        controller.view.layer.addSublayer(previewLayer)
//        cameraManager.startSession()
//        return controller
//    }
//    
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
//}
//
//#Preview {
//    CameraView(cameraManager: CameraManager())
//}
