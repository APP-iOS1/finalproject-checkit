//
//  LicenseView.swift
//  CheckIt
//
//  Created by 조현호 on 2023/02/06.
//

import SwiftUI

struct LicenseView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(
"""
Alamofire
- https://github.com/Alamofire/Alamofire

SDWebImage
- https://github.com/SDWebImage/SDWebImage

SwiftyJSON
- https://github.com/SwiftyJSON/SwiftyJSON

Kakao Login SDK for iOS
- https://developers.kakao.com/docs/latest/ko/kakaologin/ios

Firebase Apple Open Source Development
- https://github.com/firebase/firebase-ios-sdk
                
FirebaseUI
- https://github.com/firebase/FirebaseUI-iOS
                
AlertToast
- https://github.com/elai950/AlertToast

"""
                )
            }
            .padding()
        }
        .navigationBarTitle("오픈소스 라이선스")
        
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

struct LicenseView_Previews: PreviewProvider {
    static var previews: some View {
        LicenseView()
    }
}
