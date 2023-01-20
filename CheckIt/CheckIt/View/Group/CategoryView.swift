//
//  CategoryView.swift
//  CheckIt
//
//  Created by 조현호 on 2023/01/18.
//

import SwiftUI

struct CategoryView: View {
    @State var clickedIndex: Int = 0
    
    let categories: [String] = ["동아리 일정", "출석부", "동아리 정보"]
    
    var body: some View {
        VStack {
            Text("허니미니의 또구 동아리")
                .font(.title2)
                .bold()
                .padding()
            
            HStack {
                ForEach(categories.indices) { i in
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
                    .padding()
                }
            }
            .frame(width: 330)
            .padding(.bottom, 20)
            
            if clickedIndex == 0 {
                GroupScheduleView()
            }
            if clickedIndex == 1 {
                AttendanceStatusView()
            }
            if clickedIndex == 2 {
                Text("동아리 정보 뷰")
            }
            
            Spacer()
        }
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView()
    }
}
