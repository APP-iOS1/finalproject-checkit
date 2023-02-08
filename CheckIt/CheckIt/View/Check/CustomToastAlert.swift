//
//  ToastAlert.swift
//  CheckIt
//
//  Created by sole on 2023/01/20.
//

import SwiftUI

struct CustomToastAlert: View {
    @State var distance: Int = 100
    @Binding var isPresented: Bool
    var body: some View {
        if isPresented {
            toastAlertLabel
                .overlay {
                    VStack {
                        Text("모임 장소로 이동해주세요.")
                        Text("모임 위치까지 \(distance)m 남았습니다.")
                    }
                }
                .padding(.vertical, 80)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.isPresented = false
                    }
                }
        }
    }
    
    
    private var toastAlertLabel: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundColor(.toastAlertGray)
            .frame(width: 280, height: 80)
    }
}

