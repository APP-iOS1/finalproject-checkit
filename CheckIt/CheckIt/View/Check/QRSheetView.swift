//
//  QRSheetView.swift
//  CheckIt
//
//  Created by sole on 2023/01/18.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRSheetView: View {
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.myGreen, .white]),
                           startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                // 각 로그인 한 ID 정보 넣어줘야 함
                Image(uiImage: generateQRCode(from: "사용자 정보"))
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .cornerRadius(15)
            }
        }
        .presentationDragIndicator(.visible)
    }
    
    
    //MARK: - Method(generateQRCode)
    /// 문자열을 넣으면 QR 코드를 반환하는 메서드입니다.
    func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}


//MARK: - Previews
struct QRSheetView_Previews: PreviewProvider {
    static var previews: some View {
        QRSheetView()
    }
}
