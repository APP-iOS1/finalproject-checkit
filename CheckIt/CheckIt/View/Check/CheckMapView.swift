//
//  CheckMapView.swift
//  CheckIt
//
//  Created by sole on 2023/01/18.
//

import SwiftUI
import MapKit

struct CheckMapView: View {
    ///카메라 띄우기 위한 설정
    
    @State private var showCameraScannerView = false
    
    //FIXME: 테스트 코드입니다.
    @State var showQRCode: Bool = false
    @State private var isGroupHost: Bool = true //테스트용 추후에 서버에서 받은 값으로 변경 예정
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.478846, longitude: 126.620930), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @State var isAlert: Bool = false
    
    var body: some View {
        ZStack {
            
            VStack {
                
                Map(coordinateRegion: $region)
                    .ignoresSafeArea()
                    .frame(maxHeight: 450)
                Spacer()
                
                
                // 출석하기 버튼
                Button(action: { }) {
                    CheckItButtonLabel(isActive: false, text: "출석하기")
                }
                .frame(width: 338, height: 62)
                .padding(.bottom ,10)
                //FIXME: - Prototype용 코드 (출석하기 버튼이 비활성화 됐을 때 사용)
                .disabled(true)
                .onTapGesture { isAlert = true }
                
                
                
                Spacer()
                
                    .toolbar {
                        Button {
                            if isGroupHost {
                                self.showCameraScannerView.toggle()
                                
                            } else {
                                showQRCode.toggle()
                            }
                            
                        } label: {
                            QRButtonLabel()
                        }
                        
                    } // - toolbar
            } // - VStack
            
            .sheet(isPresented: isGroupHost ? $showCameraScannerView : $showQRCode) {
                
                if isGroupHost {
                    CameraScanner()
                    
                } else {
                    QRSheetView()
                        .presentationDetents([.medium])
                }
            } // - sheet
            // Toast Alert (Alert의 Opacity를 애니메이션으로 바꾸는 방식으로 수정해야 함.)
            //FIXME: 애니메이션이 보일땐 자연스러운데 없어질때 뚝 없어지는 느낌임.
            if isAlert {
                ToastAlert()
                    .offset(y: 130)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.isAlert = false
                        }
                    }
            }

            
        } // - ZStack
        //        .animation(.linear(duration: 0.3), value: isAlert)
        .animation(.easeOut(duration: 0.3), value: isAlert)
        .transition(.opacity)
        .toolbarBackground(.black.opacity(0.01), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)


    }
}

struct CheckMapView_Previews: PreviewProvider {
    static var previews: some View {
        CheckMapView()
    }
}

