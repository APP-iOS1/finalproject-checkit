//
//  ReportView.swift
//  CheckIt
//
//  Created by 이학진 on 2023/02/26.
//

import SwiftUI

struct ReportView: View {
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var groupStore: GroupStore
    @EnvironmentObject var scheduleStore: ScheduleStore
    @EnvironmentObject var attendanceStore: AttendanceStore
    @EnvironmentObject var memberStore: MemberStore
    
    @State private var content: String = ""
    @State private var placeholder: String = Constants.contentPlaceholder
    
    @Binding var cancelButtonTapped: Bool
    @Binding var showToast: Bool
    @Binding var toastObj: ToastMessage
    
    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
                .frame(height: UIScreen.screenHeight / 3)
            
            VStack(alignment: .leading) {
                Text("신고")
                    .font(.system(size: 20, weight: .bold))
                    .padding(.bottom)
                
                ZStack {
                    if content.isEmpty {
                        TextEditor(text: $placeholder)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.leading)
                            .textFieldStyle(.roundedBorder)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.myGray, lineWidth: 2)
                            )
                        
                            .disabled(true)
                            .padding(.bottom)
                    }
                    TextEditor(text: $content)
                        .multilineTextAlignment(.leading)
                        .textFieldStyle(.roundedBorder)
                        .opacity(self.content.isEmpty ? 0.25 : 1)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.myGray, lineWidth: 2)
                        )
                        .onChange(of: content) { value in
                            if value.count > Constants.reportContentLimit {
                                content.removeLast()
                            }
                        }
                        .padding(.bottom)
                }
                
                HStack {
                    Spacer()
                    Text("\(content.count) / \(Constants.reportContentLimit)")
                }
                .padding(0)
                .padding(.top, -20)
                
                Spacer()
                
                HStack {
                    Spacer()
                    Button {
                        cancelButtonTapped = false
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 100, height: 50)
                            .foregroundColor(.myGray)
                            .overlay {
                                Text("취소하기")
                                    .foregroundColor(.black)
                                    .font(.system(size: 16, weight: .bold))
                            }
                    }
                    .padding(.trailing, 18)
                    
                    Button {
                        showToast.toggle()
                        cancelButtonTapped.toggle()
                        toastObj.message = Constants.toastMeesage
                        toastObj.type = .competion
                        
                        print("신고 내용: \(content)")
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 100, height: 50)
                            .foregroundColor(.myGreen)
                            .overlay {
                                Text("신고하기")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .bold))
                            }
                    }
                    .padding(.leading, 0)
                    Spacer()
                }
            }
            .padding()
        } // - ZStack
        .frame(height: UIScreen.screenHeight / 3)
    }
}

private enum Constants {
    static let reportContentLimit: Int = 300
    static let toastMeesage: String = "신고가 완료되었습니다."
    static let contentPlaceholder: String = "신고 내용을 입력해주세요."
}
