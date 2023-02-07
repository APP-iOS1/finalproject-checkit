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
    
    @State var selectedGroup = "전체"
    //동아리 샘플 배열
    
    var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(Color.myLightGray)
                Menu {
                    Picker(selection: $selectedGroup) {
                        ForEach(groupStore.groups, id: \.self) { group in
                            Text(group.name)
                                .tag(group.name)
                        }
                    } label: {}
                } label: {
                    Text(selectedGroup)
                        .font(.body)
                        .frame(width: 170)
                }.id(selectedGroup)
            }
            .frame(width: 180, height: 35)
        }
}

struct PickerView_Previews: PreviewProvider {
    static var previews: some View {
        PickerView()
    }
}
