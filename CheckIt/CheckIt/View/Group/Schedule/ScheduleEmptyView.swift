//
//  ScheduleEmptyView.swift
//  CheckIt
//
//  Created by 조현호 on 2023/02/09.
//

import SwiftUI

struct ScheduleEmptyView: View {
    var body: some View {
        Text("아직 일정이 없어요.\n일정을 추가하여 출석 현황을 관리해 보세요.")
            .font(.title)
    }
}

struct ScheduleEmptyView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleEmptyView()
    }
}
