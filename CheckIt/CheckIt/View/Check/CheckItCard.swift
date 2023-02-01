//
//  CheckItCard.swift
//  CheckIt
//
//  Created by sole on 2023/01/18.
//

import SwiftUI

struct CheckItCard: View {
    var data: Card
    //    var isActiveButton: Bool = true
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(width: 330, height: 500)
            .foregroundColor(.gray)
            .overlay {
                VStack(alignment: .center) {
                    Spacer()
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
                    data.groupImage
                        .resizable()
                        .frame(width: 246, height: 186.81)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(10)
                    
                    
                    // Check It 버튼
                    NavigationLink(destination: CheckMapView()) {
                        CheckItButtonLabel(isActive: data.isActiveButton, text: "Check It!")
                    }
                    .frame(width: 200)
                    .padding(10)
                    .disabled(!data.isActiveButton)
                    
                    Spacer()
                    
                } // - VStack
                .frame(width: UIScreen.main.bounds.width - 20, height: data.show ? 600 : 500)
                .background(Color.white)
                .cornerRadius(25)
            } // - overlay
//            .padding(.leading, 20)
    }
    
    //MARK: - View(TopSection)
    private var TopSection: some View {
        VStack(alignment: .leading) {
            // 모임 날짜 나타내는 라벨
            DdayLabel(dDay: data.dDay)
                .padding(.top, 10)
            // 동아리 이름
            Text("\(data.groupName)")
                .font(.title.bold())
        } // - VStack
        
    } // - TopSection
    //MARK: - View(InformationSection)
    private var InformationSection: some View {
        VStack(alignment: .leading) {
            // 날짜
            HStack {
                customSymbols(name: "calendar")
                Text("\(data.date)")
            } // - HStack
            .padding(.vertical, 3)
            
            // 시간
            HStack {
                customSymbols(name: "clock")
                Text("\(data.time)")
            } // - HStack
            .padding(.vertical, 3)
            
            // 장소
            HStack {
                customSymbols(name: "mapPin")
                Text("\(data.place)")
            } // - HStack
            .padding(.vertical, 3)
        } // - VStack
    } // - InformationSection
}



//struct CheckItCard_Previews: PreviewProvider {
//    static var previews: some View {
//        CheckItCard(data: <#Card#>)
//    }
//}
