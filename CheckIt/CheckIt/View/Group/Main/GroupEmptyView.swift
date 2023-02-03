//
//  GroupEmptyView.swift
//  CheckIt
//
//  Created by 이학진 on 2023/02/03.
//

import SwiftUI

struct GroupEmptyView: View {
    var body: some View {
        Text("아직 가입된 동아리가 없어요. 동아리에 가입하여 일정에 참가하세요.")
            .font(.title)
    }
}

struct GroupEmptyView_Previews: PreviewProvider {
    static var previews: some View {
        GroupEmptyView()
    }
}
