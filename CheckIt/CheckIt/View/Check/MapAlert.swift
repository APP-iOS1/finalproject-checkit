//
//  MapAlert.swift
//  CheckIt
//
//  Created by sole on 2023/01/18.
//

import SwiftUI

struct MapAlert: View {
    var alertMessage: String = "모임 위치로 100m 이동해주세요."
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .frame(width: 246, height: 76)
            .foregroundColor(.myGray.opacity(0.7))
            .overlay {
                Text("\(alertMessage)")
            }
    }
}

struct MapAlert_Previews: PreviewProvider {
    static var previews: some View {
        MapAlert()
    }
}
