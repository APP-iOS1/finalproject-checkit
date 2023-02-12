//
//  CheckMainView.swift
//  CheckIt
//
//  Created by sole on 2023/01/18.
//

import SwiftUI

struct CheckMainView: View {
    @EnvironmentObject var groupStore: GroupStore
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var scheduleStore: ScheduleStore
    @State private var page = 0
    
    var card: [Card] {cardGenerate()}
    
    var body: some View {
        NavigationView {
            VStack {
                if groupStore.groups.isEmpty {
                    Spacer()
                    CheckEmptyView()
                    Spacer()
                } else {
                    TabView(selection: $page) {
                        ForEach(0..<groupStore.groups.count, id: \.self) { index in
                            CheckItCard(group: groupStore.groups[index], groupImage: groupStore.groupImage[groupStore.groups[index].id] ?? UIImage(), index: index, card: card, recentScheduleList: $scheduleStore.recentSchedule)
                                .tag(index)
                        }
                    }
                    .tabViewStyle(.page)
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                    .onChange(of: page) { value in print("selected tab = \(value)")
                    }
                    
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(
                        destination: MyPageView()
                                    .environmentObject(userStore),
                        label: {
                            Label("MyPage", systemImage: "person.circle")
                                .font(.title2)
                                .foregroundColor(.black)
                        })
                }
            }
        } // - NavigationView
    }
    
    //MARK: - Method(cardGenerate)
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
    } // - cardGenerate
}


////MARK: - Previews
//struct CheckMainView_Previews: PreviewProvider {
//    static var previews: some View {
//        CheckMainView()
//    }
//}
