//
//  TestAdmin.swift
//  CheckIt
//
//  Created by 황예리 on 2023/02/07.
//

import SwiftUI

struct TestAdmin: View {
    @State private var titleTextField: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("제목")
                    
                    VStack {
                        TextField("dd", text: $titleTextField)
                        
                        Divider()
                    }
                }
            }
            .navigationTitle("공지사항 추가하기")
        }
    }
}

struct TestAdmin_Previews: PreviewProvider {
    static var previews: some View {
        TestAdmin()
    }
}
