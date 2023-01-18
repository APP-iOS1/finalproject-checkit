//
//  QRButtonLabel.swift
//  CheckIt
//
//  Created by sole on 2023/01/18.
//

import SwiftUI

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
