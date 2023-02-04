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
    
    //groupStore에서 패치한 그룹들을 담아줄 배열변수
    @State private var groupsArr: [Group] = []
    //애니메이션에 넣기 위한 변수 어레이
    @State private var cardArr: [Card] = []
    
    @State var x : CGFloat = 0
    @State var count : CGFloat = 0
    @State var screen = UIScreen.main.bounds.width - 30
    @State var op : CGFloat = 0
    
    //FIXME: 더미데이터입니다.
    //    @State var data = [
    //        Card(id: 0, dDay: "D-day", groupName: "허니미니의 또구 동아리", place: "신촌 베이스볼클럽", date: "3월 24일", time: "오후 3:00 - 오후 7:00", groupImage: Image("chocobi"), isActiveButton: true, show: false),
    //        Card(id: 1, dDay: "D-day", groupName: "또리의 이력서 클럽", place: "신촌 베이스볼클럽", date: "3월 24일", time: "오후 3:00 - 오후 7:00", groupImage: Image("chocobi"), isActiveButton: false, show: false),
    //        Card(id: 2, dDay: "D-day", groupName: "노이의 SSG 응원방", place: "신촌 베이스볼클럽", date: "3월 24일", time: "오후 3:00 - 오후 7:00", groupImage: Image("chocobi"), isActiveButton: false, show: false),
    //        Card(id: 3, dDay: "D-day", groupName: "지니의 맛집탐방", place: "신촌 베이스볼클럽", date: "3월 24일", time: "오후 3:00 - 오후 7:00", groupImage: Image("chocobi"), isActiveButton: false, show: false)
    //    ]
    
    var body: some View {
        TabView {
            VStack{
                Spacer()
                HStack(spacing: 47) {
                    ForEach(0..<groupsArr.count, id: \.self) { index in
                        VStack {
                            HStack {
                                CheckItCard(cardArr: $cardArr, group: groupsArr[index], index: index)
                                    .offset(x: self.x)
                                    .onTapGesture(perform: {
                                        print("card: \(cardArr)")
                                    })
                                    .highPriorityGesture(DragGesture()
                                                         
                                        .onChanged({ (value) in
                                            
                                            if value.translation.width > 0 {
                                                self.x = value.location.x
                                            } else {
                                                self.x = value.location.x - self.screen
                                            }
                                        })
                                            .onEnded({ (value) in
                                                
                                                if value.translation.width > 0 {
                                                    if value.translation.width > ((self.screen - 80) / 2) && Int(self.count) != 0 {
                                                        
                                                        self.count -= 1
                                                        self.updateHeight(value: Int(self.count))
                                                        self.x = -((self.screen + 15) * self.count)
                                                    } else {
                                                        self.x = -((self.screen + 15) * self.count)
                                                    }
                                                } else {
                                                    if -value.translation.width > ((self.screen - 80) / 2) && Int(self.count) !=  (groupsArr.count - 1) {
                                                        
                                                        self.count += 1
                                                        self.updateHeight(value: Int(self.count))
                                                        self.x = -((self.screen + 15) * self.count)
                                                    } else {
                                                        self.x = -((self.screen + 15) * self.count)
                                                    }
                                                }
                                            })
                                    )
                            }
                            
                            HStack(spacing: 5) {
                                ForEach(cardArr.indices) { i in
                                    Capsule()
                                        .fill(Color.black.opacity(cardArr[i].show == true ? 1 : 0.4))
                                        .frame(width: cardArr[i].show == true ? 10 : 8, height: cardArr[i].show == true ? 10 : 8)
                                        .offset(y: 60)
                                }
                            }
                        }
                        .padding(.top, 60)
                    }
                    
                }
                .frame(width: UIScreen.main.bounds.width)
                .offset(x: self.op)
                
                Spacer()
                
            }
            //            .background(Color.black.opacity(0.07).edgesIgnoringSafeArea(.top))
            //            .navigationBarTitle("Carousel List")
            .animation(.spring())
            .onAppear {
                Task {
                    guard let user = userStore.user else { return }
                    print("user check: \(user)")
                    await groupStore.fetchGroups(user)
                    groupsArr = groupStore.groups
                    print("그룹패치 확인: \(groupsArr)")
                    
                    op = ((self.screen + 15) * CGFloat(groupsArr.count / 2)) - (groupsArr.count % 2 == 0 ? ((self.screen + 15) / 2) : 0)
                    
                    cardArr = []
                    groupsArr.enumerated().forEach { idx, group in
                        if idx == 0 {
                            cardArr.append(Card(isActiveButton: true, show: true))
                        } else {
                            cardArr.append(Card(isActiveButton: false, show: false))
                        }
                    }
                    
                    //                                if cardArr[idx].show == true {
                    //                                    cardArr[0].show = false
                    //                                }
                    
                    //                    data[0].show = true
                //                    for i in 1..<groupsArr.count {
                //                        if data[i].show == true {
                //                            data[0].show = false
                //                        }
                //                    }
            } // task
        }
    }
}

func updateHeight(value : Int){
    
    
    for i in 0..<groupsArr.count{
        
        cardArr[i].show = false
    }
    
    cardArr[value].show = true
}

}

////MARK: - Previews
//struct CheckMainView_Previews: PreviewProvider {
//    static var previews: some View {
//        CheckMainView()
//    }
//}
