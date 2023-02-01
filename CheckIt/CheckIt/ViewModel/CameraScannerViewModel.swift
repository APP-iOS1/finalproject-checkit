//
//  CameraScannerViewModel.swift
//  CheckIt
//
//  Created by 류창휘 on 2023/02/01.
//

import Foundation
import VisionKit
import AVKit

enum DataScannerAccessStatusType {
    case notDetermined //카메라 접근 요청
    case cameraAccessNotGranted //카메라 접근해줘야 하는 상태
    case scannerAvailable //스캐너 사용 가능
    case scannerNotAvailable //기기가 스캐너를 지원안함
    case cameraNotAvailable //기기가 카메라를 지원안함
}

@MainActor
class CameraScannerViewModel: ObservableObject {
    @Published var dataScannerAccessStatus: DataScannerAccessStatusType = .notDetermined
    
    private var isScannerAvailable: Bool {
        DataScannerViewController.isAvailable && DataScannerViewController.isSupported
    }
    
    func requestDataScannerAccessStatus() async {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            dataScannerAccessStatus = .cameraAccessNotGranted
            return
        }
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            dataScannerAccessStatus = isScannerAvailable ? .scannerAvailable : .scannerNotAvailable
        case .restricted, .denied:
            dataScannerAccessStatus = .cameraAccessNotGranted
        case .notDetermined:
            let granted = await AVCaptureDevice.requestAccess(for: .video)
            if granted {
                dataScannerAccessStatus = isScannerAvailable ? .scannerAvailable : .scannerNotAvailable
            } else {
                dataScannerAccessStatus = .cameraAccessNotGranted
            }
        default: break
        }
        
    }
    
}
