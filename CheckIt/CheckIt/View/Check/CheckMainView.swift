//
//  CheckMainView.swift
//  CheckIt
//
//  Created by sole on 2023/01/18.
//

import SwiftUI

struct CheckMainView: View {
    @State var x : CGFloat = 0
    @State var count : CGFloat = 0
    @State var screen = UIScreen.main.bounds.width - 30
    @State var op : CGFloat = 0
    
    //FIXME: 더미데이터입니다.
    @State var data = [
        Card(id: 0, dDay: "D-day", groupName: "허니미니의 또구 동아리", place: "신촌 베이스볼클럽", date: "3월 24일", time: "오후 3:00 - 오후 7:00", groupImage: Image("chocobi"), isActiveButton: true, show: false),
        Card(id: 1, dDay: "D-day", groupName: "또리의 이력서 클럽", place: "신촌 베이스볼클럽", date: "3월 24일", time: "오후 3:00 - 오후 7:00", groupImage: Image("chocobi"), isActiveButton: false, show: false),
        Card(id: 2, dDay: "D-day", groupName: "노이의 SSG 응원방", place: "신촌 베이스볼클럽", date: "3월 24일", time: "오후 3:00 - 오후 7:00", groupImage: Image("chocobi"), isActiveButton: false, show: false),
        Card(id: 3, dDay: "D-day", groupName: "지니의 맛집탐방", place: "신촌 베이스볼클럽", date: "3월 24일", time: "오후 3:00 - 오후 7:00", groupImage: Image("chocobi"), isActiveButton: false, show: false)
    ]
    
    var body: some View {
        NavigationView{
            
            VStack{
                
                Spacer()
                
                HStack(spacing: 47) {
                    
                    ForEach(data) { i in
                        VStack {
                            HStack {
                                CheckItCard(data: i)
                                    .offset(x: self.x)
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
                                                    if -value.translation.width > ((self.screen - 80) / 2) && Int(self.count) !=  (self.data.count - 1) {
                                                        
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
                            
                            HStack {
                                ForEach(0..<data.count) { i in
                                    Circle()
                                        .fill(data[i].show == true ? Color.myGray : Color.myGray.opacity(0.4))
                                        .frame(width: 15, height: 15)
                                        .offset(y: 60)
                                }
                            }
                        }
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
                
                self.op = ((self.screen + 15) * CGFloat(self.data.count / 2)) - (self.data.count % 2 == 0 ? ((self.screen + 15) / 2) : 0)
                
                self.data[0].show = true
            }
        }
    }
    
    func updateHeight(value : Int){
        
        
        for i in 0..<data.count{
            
            data[i].show = false
        }
        
        data[value].show = true
    }
    
}

//MARK: - Previews
struct CheckMainView_Previews: PreviewProvider {
    static var previews: some View {
        CheckMainView()
    }
}
