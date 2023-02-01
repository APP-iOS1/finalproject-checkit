//
//  GroupMainDetailView.swift
//  CheckIt
//
//  Created by 이학진 on 2023/02/01.
//

import SwiftUI

struct GroupMainDetailView: View {
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                ZStack(alignment: .topLeading) {
                    // MARK: - 동아리 이미지
                    Image("chocobi")
                        .resizable()
                        .frame(width: 90, height: 90)
                        .clipShape(Circle())
                    
                    ZStack {
                        // MARK: - 방장, 운영진 여부
                        Circle()
                            .fill(.white)
                            .frame(width: 25, height: 25)
                        
                        Image(systemName: "crown.fill")
                            .resizable()
                            .frame(width: 20, height: 15)
                            .foregroundColor(Color.myGreen)
                        // FIXME: - 방장은 Color.myGreen, 운영진은 Color.myOrange로 바껴야함
                    }
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 10) {
                    // MARK: - 동아리 이름
                    Text("호이의 SSG 응원방")
                        .font(.system(size: 16, weight: .semibold))
                    
                    // MARK: - 동아리 상세 내용
                    Text("We are landers\nWe are victory")
                        .font(.system(size: 13, weight: .regular))
                }
                
                Spacer()
            }
        }
    }
}

struct GroupMainDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GroupMainDetailView()
    }
}
