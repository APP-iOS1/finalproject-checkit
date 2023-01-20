//
//  PickerView.swift
//  CheckIt
//
//  Created by 윤예린 on 2023/01/18.
//

import SwiftUI

struct PickerView: View {
    
    @State var selectedGroup = "전체"
    //동아리 샘플 배열
    var groups = ["전체", "지니의 맛집 탐방", "호이의 SSG 응원방", "허니부리 또구 교실", "또리의 이력서 클럽dddddddddddddd"]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
//                .frame(width: 120)
                .foregroundColor(Color.myLightGray)
//                .padding(.horizontal)
            Menu {
                Picker(selection: $selectedGroup) {
                    ForEach(groups, id: \.self) { group in
                        Text(group)
                            .tag(group)
                    }
                } label: {}
            } label: {
                Text(selectedGroup)
                    .font(.body)
                    .lineLimit(1)
            }.id(selectedGroup)
                .frame(width: 100)
        }
        .frame(width: 130, height: 35)
    }
}

struct PickerView_Previews: PreviewProvider {
    static var previews: some View {
        PickerView()
    }
}
