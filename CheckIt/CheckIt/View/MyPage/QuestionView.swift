//
//  QuestionView.swift
//  CheckIt
//
//  Created by 류창휘 on 2023/01/18.
//

import SwiftUI
import AlertToast

struct QuestionView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var isPresentedNotionSheet: Bool = false
    @State var isPresentedWithdrawalAlert: Bool = false
    @State var isPresentedContactView: Bool = false
    @State var isPresentedMailToastAlert: Bool = false
    @State var isPresentedMailAlert: Bool = false
    @State var mailAlert: AlertToast = AlertToast(displayMode: .alert, type: .complete(.green), title: "메일을 성공적으로 전송했습니다.")
    
    @State private var frequentlyQeustionsTitle: String = "자주하는 질문"
    @State private var frequentlyQeustionsImage: String = "person.fill.questionmark"
    @State private var customServiceTitle: String = "문의하기"
    @State private var customServiceImage: String = "person.crop.circle.badge.questionmark"
    @State private var unregisterTitle: String = "회원탈퇴"
    @State private var unregisterImage: String = "x.circle"
    @State private var openSourceLicenseTitle: String = "오픈소스 라이선스"
    @State private var openSourceLicenseImage: String = "globe.central.south.asia"
    
    @State private var mailData = ComposeMailData(subject: "[문의하기]",
                                                  recipients: ["ckit.contact@gmail.com"],
                                                  message: "문의 내용을 작성해주세요.")
    
    var body: some View {
        VStack(alignment: .leading) {
            //            Button(action: { isPresentedNotionSheet = true }) {
            //                HStack {
            //                    MyPageButton(buttonTitle: $frequentlyQeustionsTitle, buttonImage: $frequentlyQeustionsImage)
            //                    Spacer()
            //                }
            //            }
            //            .padding(.top)
            //
            //
            //            Divider()
            //                .background(Color.white)
            //
            //            NavigationLink(destination: Text("문의하기")) {
            //                HStack {
            //                    MyPageButton(buttonTitle: $customServiceTitle, buttonImage: $customServiceImage)
            //                    Spacer()
            //                }
            //            }
            //
            //            Divider()
            //                .background(Color.white)
            
            // 오픈소스 라이선스
            
            //            NavigationLink(destination: LicenseView()) {
            //                HStack {
            //                    MyPageButton(buttonTitle: $openSourceLicenseTitle, buttonImage: $openSourceLicenseImage)
            //                    Spacer()
            //                }
            //            }
            Button(action: {
                if ContactView.canSendMail {
                    isPresentedContactView = true
                } else {
                    isPresentedMailAlert = true
                }
            }) {
                HStack {
                    MyPageButton(buttonTitle: .constant("문의 메일 보내기"), buttonImage: .constant("mail"))
                    Spacer()
                }
            }
            
            
            Divider()
                .background(Color.white)
            
            // 회원탈퇴
            Button(action: {
                isPresentedWithdrawalAlert = true
            }) {
                HStack {
                    MyPageButton(buttonTitle: $unregisterTitle, buttonImage: $unregisterImage)
                    Spacer()
                }
            }
            .foregroundColor(.myGray)
            
            Spacer()
        }
        .padding(.horizontal, 30)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                }
            }
        }
        .overlay {
            if isPresentedWithdrawalAlert {
                withdrawalAlert
            }
        }
        .alert(isPresented: $isPresentedMailAlert) {
            Alert(title: Text("개발자에게 문의하기"), message: Text("문의사항은 ckit.contact@gmail.com 으로 보내주시길 바랍니다."))
        }
        .sheet(isPresented: $isPresentedContactView) {
            ContactView(data: $mailData) { result in
                switch result {
                case .success(let result):
                    switch result {
                        // 작성 취소, 임시 저장
                    case .cancelled, .saved:
                        break
                        // 전송에 실패한 경우
                    case .failed:
                        mailAlert = AlertToast(displayMode: .alert, type: .error(.red), title: "메일 전송에 실패했습니다! 다시 시도해주세요.")
                        isPresentedMailToastAlert = true
                        // 성공적으로 전송한 경우
                    case .sent:
                        mailAlert = AlertToast(displayMode: .alert, type: .complete(.green), title: "메일을 성공적으로 전송했습니다!")
                        isPresentedMailToastAlert = true
                    }
                    // 전송 실패
                case .failure(let error):
                    print("\(error.localizedDescription)")
                    mailAlert = AlertToast(displayMode: .alert, type: .error(.red), title: "메일 전송에 실패했습니다!")
                    isPresentedMailToastAlert = true
                }
            }
        }
        .toast(isPresenting: $isPresentedMailToastAlert) {
            mailAlert
        }
        
    }
    
    //MARK: - View
    private var withdrawalAlert: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black.opacity(0.4))
                .ignoresSafeArea()
            WithdrawalAlert(cancelButtonTapped: $isPresentedWithdrawalAlert)
                .padding(.horizontal, 30)
        }
        .transition(AnyTransition.opacity.animation(.easeOut(duration: 0.5)))
    }
    
}

