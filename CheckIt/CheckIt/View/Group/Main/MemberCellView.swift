//
//  MemberCellView.swift
//  CheckIt
//
//  Created by 황예리 on 2023/01/23.
//

import SwiftUI

struct MemberCellView: View {
    var body: some View {
        VStack {
            
            ZStack {
                Capsule()
                    .strokeBorder(Color.myGreen, lineWidth: 2)
                    .background(Color.black)
                    .clipped()
                    .frame(width: 65, height: 30)
                
                Text("방장")
                    .font(.headline)
                    .foregroundColor(Color.myGreen)
            }
            
            ZStack {
                Capsule()
                    .strokeBorder(Color.myOrange, lineWidth: 2)
                    .background(Color.white)
                    .clipped()
                    .frame(width: 65, height: 30)
                
                Text("운영진")
                    .font(.headline)
                    .foregroundColor(Color.myOrange)
            }
            
            ZStack {
                Capsule()
                    .strokeBorder(.black, lineWidth: 2)
                    .background(Color.white)
                    .clipped()
                    .frame(width: 65, height: 30)
                
                Text("구성원")
                    .font(.headline)
                    .foregroundColor(.black)
            }
            
            Text("구성원")
                .background(
                        Capsule()
                            .strokeBorder(Color.black,lineWidth: 2)
                            .background(Color.blue)
                            .clipped()
                    )
                    .clipShape(Capsule())
        }
    }
}

struct MemberCellView_Previews: PreviewProvider {
    static var previews: some View {
        MemberCellView()
    }
}
