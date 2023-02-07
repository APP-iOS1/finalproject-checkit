//
//  CheckMainView.swift
//  CheckIt
//
//  Created by sole on 2023/01/18.
//

import SwiftUI

struct CheckMainView: View {
    
    let cards: [CheckItCard] = [
        CheckItCard(),
        CheckItCard(dDay: "D-1", groupName: "또리의 이력서 클럽", place: "홍대 이력서가 젤조아", date: "3월 25일", time: "오후 6:00 - 오후 8:00", isActiveButton: false),
        CheckItCard(dDay: "D-21", groupName: "노이의 SSG 응원방", place: "이기자 빌딩", date: "4월 14일", time: "오후 7:00 - 오후 9:00", isActiveButton: false),
        CheckItCard(dDay: "-", groupName: "지니의 맛집탐방", place: "-", date: "-", time: "-", isActiveButton: false)
    ]
    
    
    var body: some View {
        NavigationStack {
            TabView {
                ForEach(cards.indices) { index in
                    cards[index]
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        }
    }
}

////MARK: - Previews
//struct CheckMainView_Previews: PreviewProvider {
//    static var previews: some View {
//        CheckMainView()
//    }
//}
