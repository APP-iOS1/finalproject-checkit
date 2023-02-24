//
//  PickerView.swift
//  CheckIt
//
//  Created by 윤예린 on 2023/01/18.
//

import SwiftUI

struct PickerView: View {
    @EnvironmentObject var groupStore: GroupStore
    @EnvironmentObject var scheduleStore: ScheduleStore
    
//    @State private var selectedGroup = "전체"
    @Binding var selectedGroup: String
    
    var pickerList: [String] {
        var groupNameList: [String] = []
        groupStore.groups.forEach { group in
            groupNameList.append(group.name)
        }
        
        return ["전체"] + groupNameList
    }
    //동아리 샘플 배열
    
    var body: some View {
        HStack {
            Menu {
                Picker(selection: $selectedGroup) {
                    ForEach(pickerList, id: \.self) { menu in
                        Text(menu)
                            .tag(menu)
                    }
                } label: {}
            } label: {
                Text(selectedGroup)
                    .font(.body)
                Image(systemName: "chevron.down")
            }.id(selectedGroup)
            Spacer()
        }
        .frame(width: 180, height: 35)
        }
    
}

