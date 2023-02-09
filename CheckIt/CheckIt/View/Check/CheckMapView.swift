//
//  CheckMapView.swift
//  CheckIt
//
//  Created by sole on 2023/01/18.
//
import CoreLocation
import SwiftUI
import MapKit

struct CheckMapView: View {
    ///카메라 띄우기 위한 설정
    @State private var showCameraScannerView = false
    @State var showQR: Bool = false
    @State var showsUserLocation: Bool = true
    @State var userTrackingMode: MapUserTrackingMode = .follow
    @State private var isGroupHost: Bool = false //테스트용 추후에 서버에서 받은 값으로 변경 예정
    
    @EnvironmentObject var scheduleStore: ScheduleStore
    @EnvironmentObject var userStore: UserStore
    var group: Group
    var isHost: Bool {
        group.hostID == userStore.user?.id ?? ""
    }
    
    
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.478846, longitude: 126.620930), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    var isActive: Bool = false
    @State var isAlert: Bool = false
    
    var body: some View {
        VStack {
           
            // MapView
            MapViewWithUserLocation()
            
                .overlay(alignment: .bottom) {
                    VStack {
                        // 토스트 알럿
                        CustomToastAlert(isPresented: $isAlert)
                        
                        // 출석하기 버튼, isActive가 false면 자동으로 disable됨
                        CheckItButton(isActive: isActive, isAlert: $isAlert, text: "출석하기") {
                           // 출석 범위에 들어왔을 때 action
                        
                        }
                        .frame(width: 338)
                        .padding(.bottom ,10)
                        .offset(y: -50)
                    } // - VStack
                } // - overlay
            
            
            // QR 시트 버튼
                .toolbar {
                    Button (action: {
                        showQR.toggle()


                    }) { QRButtonLabel() }
                } // - toolbar
            
            
            // QR 시트
                .sheet(isPresented: $showQR) {
                    if isGroupHost {
                        CameraScanner()
     
 
                    } else {
                        QRSheetView()
                            .presentationDetents([.medium])
                            .environmentObject(userStore)
                    }
                    
                } // - sheet

       
    
            
        } // - VStack
        .animation(.easeOut(duration: 0.3), value: isAlert)
        .transition(.opacity)
        .toolbarBackground(Material.ultraThinMaterial, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .onAppear {
            print(userStore.user?.id, "유저 아이디")
        }
    }
}





//struct CheckMapView_Previews: PreviewProvider {
//    static var previews: some View {
//        CheckMapView()
//    }
//}
//
