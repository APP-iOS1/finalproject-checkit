//
//  ToastAlert.swift
//  CheckIt
//
//  Created by sole on 2023/01/20.
//

import SwiftUI

//MARK: - Enum(AlertMode)
enum AlertMode: String {
    case time
    case place
    case complete
}

//MARK: - View(CustomToastAlert)
struct CustomToastAlert: View {
    
    @Binding var distance: Double
    @Binding var isPresented: Bool
    @Binding var mode: AlertMode
    
    var body: some View {
        if isPresented {
            toastAlertLabel
                .overlay {
                   displayText
                }
                .padding(.vertical, 80)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.isPresented = false
                    }
                }
        }
    }
    
    //MARK: - View(displayText)
    private var displayText: some View {
        switch mode {
        case .time:
            return AnyView(Text("출석체크 시간이 아닙니다!"))
        case .place:
            return AnyView(
            VStack {
            Text("모임 장소로 이동해주세요.")
            Text("모임 위치까지 ") + Text(convertMeterToKiloMeter(meter: distance)).bold() + Text(" 남았습니다.")
            })
        case .complete:
            return AnyView(Text("출석이 이미 완료되었습니다."))
        default:
            return AnyView(Text(""))
        }
        AnyView(Text(""))
    } // - displayText
    
    
    
    
    //MARK: - toastAlertLabel
    private var toastAlertLabel: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundColor(.toastAlertGray)
            .frame(width: 280, height: 80)
    } // - toastAlertLabel
    
    func convertMeterToKiloMeter(meter: Double) -> String {
        let meter = Int(meter)
        return meter < 1000 ? "\(meter)m": "\(meter / 1000)km"
    }
}

