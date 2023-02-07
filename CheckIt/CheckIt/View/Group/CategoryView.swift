//
//  CategoryView.swift
//  CheckIt
//
//  Created by 조현호 on 2023/01/18.
//

import SwiftUI

struct CategoryView: View {
    @State var clickedIndex: Int = 0
    @EnvironmentObject var scheduleStore: ScheduleStore
    @EnvironmentObject var memberStore: MemberStore
    
    let categories: [String] = ["동아리 일정", "출석부", "동아리 정보"]
    var group: Group
    
    var body: some View {
        VStack {
            Text(group.name)
                .font(.title2)
                .bold()
                .padding()
            
            HStack {
                ForEach(categories.indices, id: \.self) { i in
                    Button(action: {
                        clickedIndex = i
                    }, label: {
                        if i == 1 {
                            Text(categories[i])
                                .foregroundColor(i == clickedIndex ? .black : .gray)
                                .background(i == clickedIndex ?
                                            Color.black
                                    .frame(
                                        width: 70,
                                        height: 3)
                                    .offset(y: 17)
                                            :
                                                Color.white
                                    .frame(height: 3)
                                    .offset(y: 15)
                                )
                                .font(i == clickedIndex ? .system(size: 18).bold(): .system(size: 18))
                        } else {
                            Text(categories[i])
                                .foregroundColor(i == clickedIndex ? .black : .gray)
                                .background(i == clickedIndex ?
                                            Color.black
                                    .frame(
                                        width: 100,
                                        height: 3)
                                        .offset(y: 17)
                                            :
                                                Color.white
                                    .frame(height: 3)
                                    .offset(y: 15)
                                )
                                .font(i == clickedIndex ? .system(size: 18).bold(): .system(size: 18))
                        }
                    })
                    .padding(.top)
                    .padding(.horizontal)
                }
            }
            .frame(width: 330)
            .padding(.bottom, 20)
            
            if clickedIndex == 0 {
                GroupScheduleView(group: group)
            }
            if clickedIndex == 1 {
                AttendanceStatusView(scheduleIDList: group.scheduleID, hostId: group.hostID)
            }
            if clickedIndex == 2 {
                GroupInformationView(group: group)
            }
            
            Spacer()
        }
        .onAppear {
            print(group.name, "네임")
            print(group.scheduleID, "Sssss")
            scheduleStore.fetchSchedule(gruopName: group.name)
            
            memberStore.members.removeAll()
            Task {
                do {
                    try await memberStore.fetchMember(group.id)
                } catch MemberError.notFoundMember {
                    print("member를 못찾음")
                } catch {
                    print("not found error")
                }
            }
            
        }
        .onDisappear {
            print(group.scheduleID, "---------")
        }
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(group: Group.sampleGroup)
            .environmentObject(ScheduleStore())
            .environmentObject(MemberStore())
    }
}
