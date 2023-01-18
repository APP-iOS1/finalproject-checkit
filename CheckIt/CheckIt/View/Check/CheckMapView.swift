//
//  CheckMapView.swift
//  CheckIt
//
//  Created by sole on 2023/01/18.
//

import SwiftUI
import MapKit

struct CheckMapView: View {
    //FIXME: 테스트 코드입니다. 
    @State var isPresentedQR: Bool = false
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.478846, longitude: 126.620930), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @State var isAlert: Bool = false
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $region)
                .ignoresSafeArea()
                .frame(height: 500)
            Spacer()
            
            
            
            // 출석하기 버튼
            Button(action: {
                
            }) {
                CheckItButtonLabel(isActive: false, text: "출석하기")
                    .frame(width: 338, height: 62)
            }
            .padding(.bottom ,10)
            
            
            //FIXME: - Prototype용 코드
            .disabled(true)
            .onTapGesture {
                isAlert.toggle()
            }
            // 위치에 도착하지 않았는데 출석하기 버튼을 누른 경우 임시 알림
            .alert("모임 위치로 이동해주세요.\n 100m 이동해주세요.", isPresented: $isAlert){}
            
            Spacer()
            
            
            
            .toolbar {
                Button(action: { isPresentedQR.toggle() } ) {
                    QRButtonLabel()
                }
                    
            } // - toolbar
        } // - VStack
        .sheet(isPresented: $isPresentedQR) {
            QRSheetView()
                .presentationDetents([.medium])
        } // - sheet
    }
    
    
}

struct CheckMapView_Previews: PreviewProvider {
    static var previews: some View {
        CheckMapView()
    }
}

