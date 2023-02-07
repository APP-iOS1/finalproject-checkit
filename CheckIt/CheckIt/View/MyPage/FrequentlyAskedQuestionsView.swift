//
//  FrequentlyAskedQuestionsView.swift
//  CheckIt
//
//  Created by 조현호 on 2023/02/06.
//

import SwiftUI

struct FrequentlyAskedQuestionsView: View {
    var body: some View {
        ScrollView {
            Text("질문티비~")
                .padding()
        }
        .navigationBarTitle("자주하는 질문")
    }
}

struct FrequentlyAskedQuestionsView_Previews: PreviewProvider {
    static var previews: some View {
        FrequentlyAskedQuestionsView()
    }
}
