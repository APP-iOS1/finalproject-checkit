//
//  ToastAlert.swift
//  CheckIt
//
//  Created by sole on 2023/01/20.
//

import SwiftUI

struct ToastAlert: View {
    @State var distance: Int = 100
    var body: some View {
        toastAlertLabel
            .overlay {
                VStack {
                    Text("모임 장소로 이동해주세요.")
                    Text("모임 위치까지 \(distance)m 남았습니다.")
                }
            }
    }
    
    
    
    private var toastAlertLabel: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundColor(.toastAlertGray)
            .frame(width: 280, height: 80)
    }
}

struct ToastAlert_Previews: PreviewProvider {
    static var previews: some View {
        ToastAlert()
    }
}
