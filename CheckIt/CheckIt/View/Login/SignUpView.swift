//
//  SignUpView.swift
//  CheckIt
//
//  Created by sole on 2023/02/05.
//

import SwiftUI

struct SignUpView: View {
    @State var name: String = ""
    var body: some View {
        VStack {
            TextField("이름을 입력해주세요", text: $name)
            
            Button(action: {}) {
                Text("Submit")
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
