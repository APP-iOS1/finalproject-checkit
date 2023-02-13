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
    
    var card: [Card] {
        print("card")
        return cardGenerate()
    }
    
    let swapIndex: SwapIndex = SwapIndex()
//    var swapedGroups: [Group] = []
//
    var body: some View {
        NavigationView {
            VStack {
                if groupStore.groups.isEmpty {
                    Spacer()
                    CheckEmptyView()
                    Spacer()
                } else {
                    let sortedRecentSchedule = scheduleStore.recentSchedule.sorted {
                        $0.startTime > $1.startTime
                    }
                    let swaped = swapIndex.swapGroups(groups: groupStore.groups, recentSchedules: sortedRecentSchedule)
                    
                    TabView(selection: $page) {
                        ForEach(0..<swaped.count, id: \.self) { index in
                            CheckItCard(group: swaped[index], groupImage: groupStore.groupImage[swaped[index].id] ?? UIImage(), index: index, card: card, recentScheduleList: $scheduleStore.recentSchedule)
                                .tag(index)
                        }
                    }
                    .tabViewStyle(.page)
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                    .onChange(of: page) { value in print("selected tab = \(value)")
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(
                        destination: MyPageView()
                            .environmentObject(userStore),
                        label: {
                            Label("MyPage", systemImage: "person.circle")
                                .font(.title2)
                                .foregroundColor(.primary)
                                .padding([.top,.leading,.trailing])
                        })
                }
            }
        } // - NavigationView
    }
    
    //MARK: - Method(cardGenerate)
    func cardGenerate() -> [Card] {
        var tempCard: [Card] = []
        for (i, group) in groupStore.groups.enumerated() {
            if let filterSchedule = scheduleStore.recentSchedule.first(where: { schedule in
                return schedule.groupName == group.name
            }) {
                switch page {
                case i:
                    if D_days().days(to: filterSchedule.startTime) != 0 {
                        tempCard.append(Card(isActiveButton: false, show: true))
                    } else {
                        tempCard.append(Card(isActiveButton: true, show: true))
                    }
                default:
                    if D_days().days(to: filterSchedule.startTime) != 0 {
                        tempCard.append(Card(isActiveButton: false, show: false))
                    } else {
                        tempCard.append(Card(isActiveButton: true, show: false))
                    }
                }
            } else {
                if page != i {
                    tempCard.append(Card(isActiveButton: false, show: false))
                } else {
                    tempCard.append(Card(isActiveButton: false, show: true))
                }
            }
        }
        return tempCard
    } // - cardGenerate
}

class SwapIndex {
    var num: Int = 0
    var copied: [Group] = []
    
    func swapGroups(groups: [Group], recentSchedules: [Schedule]) -> [Group] {
        self.copied = groups
        
        for index in 0..<recentSchedules.count {
            if let i = copied.firstIndex(where: { $0.scheduleID.contains(recentSchedules[index].id)
            }) {
                print("i: \(i)")
                print("num : \(num)")
                print("--------------------")
                
                let pop = copied.remove(at: i)
                copied.insert(pop, at: 0)
            }
        }
        print("copied: \(copied)")
        return copied
    }
}

//MARK: - 일정 디데이 계산해주는 함수
struct D_days {
    let calendar = Calendar.current
    
    func days(to date: Date) -> Int {
        //지금 날짜
        var nowComponents = DateComponents()
        nowComponents.day = calendar.dateComponents([.day], from: Date()).day
        nowComponents.month = calendar.dateComponents([.month], from: Date()).month
        nowComponents.year = calendar.dateComponents([.year], from: Date()).year
        
        let fromDate = calendar.date(from: nowComponents)
        
        //일정 날짜
        var components = DateComponents()
        components.day = calendar.dateComponents([.day], from: date).day
        components.month = calendar.dateComponents([.month], from: date).month
        components.year = calendar.dateComponents([.year], from: date).year
        
        let toDate = calendar.date(from: components)
        
        // 00시 00분을 기준으로 계산
        return (calendar.dateComponents([.day], from: fromDate!, to: toDate!).day ?? 0)
    }
}
////MARK: - Previews
//struct CheckMainView_Previews: PreviewProvider {
//    static var previews: some View {
//        CheckMainView()
//    }
//}
