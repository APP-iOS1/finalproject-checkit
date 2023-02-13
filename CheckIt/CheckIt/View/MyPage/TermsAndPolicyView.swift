//
//  TermsAndPolicyView.swift
//  CheckIt
//
//  Created by 황예리 on 2023/02/11.
//

import SwiftUI

struct TermsAndPolicyView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var termsButtonTitle: String = "이용약관"
    @State private var termsButtonImage: String = "list.clipboard"
    @State private var openSourceLicenseTitle: String = "오픈소스 라이선스"
    @State private var openSourceLicenseImage: String = "globe.central.south.asia"
    
    var body: some View {
        VStack(alignment: .leading) {
            
            NavigationLink(destination: TermsConditionsView()) {
                HStack {
                    MyPageButton(buttonTitle: $termsButtonTitle, buttonImage: $termsButtonImage)
                    Spacer()
                }
            }
            .padding(.top)
            
            Divider()
            
            NavigationLink(destination: LicenseView()) {
                HStack {
                    MyPageButton(buttonTitle: $openSourceLicenseTitle, buttonImage: $openSourceLicenseImage)
                    Spacer()
                }
            }
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
    }
}

struct TermsAndPolicyView_Previews: PreviewProvider {
    static var previews: some View {
        TermsAndPolicyView()
    }
}
