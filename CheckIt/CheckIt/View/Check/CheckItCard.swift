//
//  CheckItCard.swift
//  CheckIt
//
//  Created by sole on 2023/01/18.
//

import SwiftUI

struct CheckItCard: View {
//    @Binding var isPresentedMapView: Bool 
    @State var dDay: String = "D-day"
    @State var groupName: String = "허니미니의 또구 동아리"
    @State var place: String = "신촌 베이스볼클럽"
    @State var date: String = "3월 24일"
    @State var time: String = "오후 3:00 - 오후 7:00"
    @State var groupImage: Image = Image("chocobi")
    var isActiveButton: Bool = true
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(width: 330, height: 600)
            .foregroundColor(.myLightGray)
            .overlay {
                VStack(alignment: .center) {
                   
                        VStack(alignment: .leading) {
                            HStack {
                                TopSection
                                Spacer()
                            }
                            
                            HStack {
                                InformationSection
                                Spacer()
                            }
                        } // - VStack
                        .frame(width: 280)
                        .padding(10)
                        
                        
                        //동아리 사진
                        groupImage
                            .resizable()
                            .frame(width: 246, height: 186.81)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(10)

                        
                    // Check It 버튼
                    NavigationLink(destination: CheckMapView()) {
                            CheckItButtonLabel(isActive: isActiveButton, text: "Check It!")
                        }
                        .frame(width: 200)
                        .padding(10)
                        .disabled(!isActiveButton)
                    
                        Spacer()
                    
                } // - VStack
            } // - overlay
    }
    
    //MARK: - View(TopSection)
    private var TopSection: some View {
            VStack(alignment: .leading) {
                // 모임 날짜 나타내는 라벨
                DdayLabel(dDay: dDay)
                    .padding(.top, 10)
                // 동아리 이름
                Text("\(groupName)")
                    .font(.title.bold())
            } // - VStack
        
    } // - TopSection
    //MARK: - View(InformationSection)
    private var InformationSection: some View {
        VStack(alignment: .leading) {
            // 날짜
            HStack {
                customSymbols(name: "calendar")
                Text("\(date)")
            } // - HStack
            .padding(.vertical, 3)
            
            // 시간
            HStack {
                customSymbols(name: "clock")
                Text("\(time)")
            } // - HStack
            .padding(.vertical, 3)
            
            // 장소
            HStack {
                customSymbols(name: "mapPin")
                Text("\(place)")
            } // - HStack
            .padding(.vertical, 3)
        } // - VStack
    } // - InformationSection
    
}



struct CheckItCard_Previews: PreviewProvider {
    static var previews: some View {
        CheckItCard()
    }
}
