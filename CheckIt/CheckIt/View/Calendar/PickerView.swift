//
//  PickerView.swift
//  CheckIt
//
//  Created by 윤예린 on 2023/01/18.
//

import SwiftUI

struct PickerView: View {
    
    @State var selectedGroup = "전체"
    var groups = ["전체", "지니의 맛집 탐방", "호이의 SSG 응원방", "허니부리 또구 교실", "또리의 이력서 클럽"]
    
    var body: some View {
//        Picker("Choose a group", selection: $selectedGroup) {
//            ForEach(groups, id: \.self) { group in
//                Text(group)
//                    .font(.caption2)
//                    .lineLimit(1)
//            }
//        }
//        .padding()
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
    }
}

struct PickerView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
