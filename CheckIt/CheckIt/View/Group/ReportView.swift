//
//  ReportView.swift
//  CheckIt
//
//  Created by 이학진 on 2023/02/26.
//

import SwiftUI

struct ReportView: View {
    @EnvironmentObject var userStore: UserStore
    
    @State private var content: String = ""
    @State private var placeholder: String = Constants.contentPlaceholder
    @State private var isReport: Bool = false
    
    @Binding var cancelButtonTapped: Bool
    @Binding var showToast: Bool
    @Binding var toastObj: ToastMessage
    
    var group: Group
    
    var body: some View {
        ZStack(alignment: .top) {
            if isReport {
                ReportConfirmView(cancelButtonTapped: $cancelButtonTapped)
            } else {
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
                            Task {
                                guard let user = userStore.user else {
                                    showToast.toggle()
                                    cancelButtonTapped.toggle()
                                    toastObj.message = Constants.userErrorMessage
                                    toastObj.type = .competion
                                    return
                                }
                                
                                let report = Report(id: UUID().uuidString,
                                                    groupId: group.id,
                                                    reporterId: user.id,
                                                    content: self.content,
                                                    date: Date())
                                
                                let result = await ReportManager.shared.reportGroup(report)
                                reportClub(result: result)
                            }
                        } label: {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 100, height: 50)
                                .foregroundColor(.myGreen)
                                .overlay {
                                    Text("신고하기")
                                        .foregroundColor(.white)
                                        .font(.system(size: 16, weight: .bold))
                                        .opacity(content.isEmpty ? 0.4 : 1)
                                }
                        }
                        .disabled(content.isEmpty ? true : false)
                        .padding(.leading, 0)
                        Spacer()
                    }
                }
                .padding()
            }
        }
        
        .frame(height: UIScreen.screenHeight / 3)
    }
    
    struct ReportConfirmView: View {
        @Binding var cancelButtonTapped: Bool
        var body: some View {
            
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.white)
                    .frame(height: UIScreen.screenHeight * 0.45)
                
                VStack(alignment: .leading) {
                    Text("신고 완료")
                        .font(.system(size: 20, weight: .bold))
                        .padding(.bottom)
                    
                    Text(Constants.reportConfirmMessage)
                        .font(.system(size: 14))
                    
                    Link(Constants.managerEmail, destination: URL(string: Constants.managerEmail)!)
                        .padding(.vertical, 5)
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        Button {
                            cancelButtonTapped = false
                        } label: {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 100, height: 50)
                                .foregroundColor(.myGreen)
                                .overlay {
                                    Text("확인")
                                        .foregroundColor(.black)
                                        .font(.system(size: 16, weight: .bold))
                                }
                        }
                        Spacer()
                    }
                }
                .padding()
            } // - ZStack
            .frame(height: UIScreen.screenHeight * 0.45)
        }
    }
    
    private func reportClub(result: Result<String, ReportError>) {
        switch result {
        case .success(let success):
            isReport.toggle()
        case .failure(let failure):
            cancelButtonTapped.toggle()
            showToast.toggle()
            toastObj.message = failure.rawValue
            toastObj.type = .failed
        }
    }
}

private enum Constants {
    static let reportContentLimit: Int = 300
    static let contentPlaceholder: String = "신고 내용을 입력해주세요."
    static let userErrorMessage: String = "알수 없는 에러 입니다."
    static let managerEmail: String = "hmheo128@gmail.com"
    static let reportConfirmMessage: String =
    """
    신고가 접수되었습니다. 신고된 동아리는 담당자가 이용약관 및 운영원칙에 따라 적절한 조치를 취하고 있습니다.
    
    신고가 접수 되면 24시간 내 검토가 진행되며 이용약관에 위배된다고 판단되는 경우, 해당 동아리는 운영 정지 처리가 진행됩니다.
    
    이와 관련하여 자세한 문의는 아래 연락처로 연락 부탁드립니다.
    """
}



