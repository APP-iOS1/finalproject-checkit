//
//  CheckMainView.swift
//  CheckIt
//
//  Created by sole on 2023/01/18.
//

import SwiftUI

struct CheckMainView: View {
    @EnvironmentObject var groupStore: GroupStore
    @EnvironmentObject var scheduleStore: ScheduleStore
    @State private var page = 0
    var card: [Card] {cardGenerate()}
    
    var body: some View {
        NavigationStack {
            TabView(selection: $page) {
                ForEach(0..<groupStore.groups.count, id: \.self) { index in
                    CheckItCard(group: groupStore.groups[index], index: index, card: card)
                        .tag(index)
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            .onChange(of: page) { value in print("selected tab = \(value)")
            }
        }
    }
    
    func cardGenerate() -> [Card] {
            var tempCard: [Card] = []
            for i in 0..<groupStore.groups.count {
                switch page {
                case i:
                    if i != 0 {
                        tempCard.append(Card(isActiveButton: false, show: true))
                    } else {
                        tempCard.append(Card(isActiveButton: true, show: true))
                    }
                default:
                    if i != 0 {
                        tempCard.append(Card(isActiveButton: false, show: false))
                    } else {
                        tempCard.append(Card(isActiveButton: true, show: false))
                    }
                }
            }
            return tempCard
        }
}

////MARK: - Previews
//struct CheckMainView_Previews: PreviewProvider {
//    static var previews: some View {
//        CheckMainView()
//    }
//}
