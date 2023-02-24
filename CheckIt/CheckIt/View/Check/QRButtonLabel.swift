//
//  QRButtonLabel.swift
//  CheckIt
//
//  Created by sole on 2023/01/18.
//

import SwiftUI

/// 출석하기 뷰 안에서 QR 버튼의 라벨입니다.
struct QRButtonLabel: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .foregroundColor(.white)
            .frame(width: 35, height: 35)
            .overlay{
                Image(systemName: "qrcode.viewfinder")
                    .resizable()
                    .frame(width: 35, height: 35)
                    .foregroundColor(.black)
            }
    }
}

struct QRButtonLabel_Previews: PreviewProvider {
    static var previews: some View {
        QRButtonLabel()
    }
}
