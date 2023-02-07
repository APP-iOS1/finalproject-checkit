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
    
    //동아리 샘플 배열
    
    var body: some View {
        HStack {
            Text(selectedGroup)
                .font(.body)

            Menu {
                Picker(selection: $selectedGroup) {
                    ForEach(groupStore.groups, id: \.self) { group in
                        Text(group.name)
                            .tag(group.name)
                    }
                } label: {}
            } label: {
                Image(systemName: "chevron.down")
            }.id(selectedGroup)
            Spacer()
        }
        .frame(width: 180, height: 35)
        }
    
}

