//
//  AttendanceView.swift
//  CheckIt
//
//  Created by 이학진 on 2023/01/18.
//

import SwiftUI

struct AttendanceView: View {
    var sampleAttendance = [1,2,3,4,5]
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack{
                    ForEach(sampleAttendance, id: \.self) { idx in
                        NavigationLink(destination: AttendanceDetailView()) {
                            AttendanceCellView()
                        }
                    }
                }
            }
        }
    }
}

struct AttendanceView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AttendanceView()
        }
    }
}




