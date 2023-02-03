//
//  GroupMainDetailView.swift
//  CheckIt
//
//  Created by 이학진 on 2023/02/01.
//

import SwiftUI

struct GroupMainDetailView: View {
    let group: Group
    let groupImage: UIImage
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                ZStack(alignment: .topLeading) {
                    // MARK: - 동아리 이미지
                    Image(uiImage: groupImage)
                        .resizable()
                        .frame(width: 85, height: 85)
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
                    Text(group.name)
                        .font(.system(size: 18, weight: .semibold))
                    
                    // MARK: - 동아리 상세 내용
                    Text(group.description)
                        .font(.system(size: 15, weight: .regular))
                }
                .foregroundColor(.black)
                
                Spacer()
            }
        }
    }
}

struct GroupMainDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GroupMainDetailView(group: Group.sampleGroup, groupImage: UIImage())
    }
}
