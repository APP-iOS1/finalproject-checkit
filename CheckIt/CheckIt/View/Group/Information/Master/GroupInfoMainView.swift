//
//  GroupInfoMainView.swift
//  CheckIt
//
//  Created by 이학진 on 2023/02/06.
//

import SwiftUI

struct GroupInfoMainView: View {
    @State var memberTest: [MemberTest] =
    [
        MemberTest(position: "구성원", memberName: "류창휘"),
        MemberTest(position: "방장", memberName: "허님니"),
        MemberTest(position: "운영진", memberName: "지니"),
        MemberTest(position: "운영진", memberName: "예린스"),
        MemberTest(position: "운영진", memberName: "호이"),
        MemberTest(position: "구성원", memberName: "또리")
    ]
    
    var body: some View {
        
        HStack(spacing: 25) {
            //동아리 이미지
            Image("chocobi")
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(Color.myGray, lineWidth: 2)
                }
            
            //동아리 정보
            VStack(alignment: .leading, spacing: 10) {
                Text("허니미니의 또구 동아리")
                    .font(.system(size: 16, weight: .bold))
                Text("허니부리의 혼과 열쩡이 가득한 야구교실 입니다. 환영합니다.")
                    .font(.system(size: 13, weight: .regular))
                    .lineLimit(3)
            }
        }
        .padding(.horizontal, 32)
        .padding(.bottom, 20)
        
        //동아리 멤버 리스트
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.myLightGray)
            VStack {
                HStack {
                    Text("동아리 멤버 리스트")
                        .font(.system(size: 16, weight: .semibold))
                        .padding(.leading, 28)
                        .padding(.trailing, 0)
                    Spacer()
                    Text("\(memberTest.count) /10 명")
                        .font(.system(size: 16, weight: .semibold))
                    Button {
                        print("dd")
                    } label: {
                        Image(systemName: "pencil.circle")
                            .foregroundColor(.black)
                    }
                    .padding(.trailing, 26)
                }
                .padding(.vertical, 20)
                
                Spacer()
                
                ScrollView {
                    VStack {
                        ForEach($memberTest, id: \.self) { list in
                            GroupMemberListCell(data: list)
                                .padding(.horizontal, 24)
                                .padding(.bottom, 5)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 32)
        .padding(.bottom, 8) //아직 기준을 잘 모르겠음
    }
}

struct GroupInfoMainView_Previews: PreviewProvider {
    static var previews: some View {
        GroupInfoMainView()
    }
}
