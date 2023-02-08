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
        VStack {
            Map(coordinateRegion: $region)
                .ignoresSafeArea()
                .overlay(alignment: .bottom) {
                    // 출석하기 버튼
                    VStack {
                        if isAlert {
                            ToastAlert()
                                .padding(.vertical, 100)
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        self.isAlert = false
                                    }
                                }
                        }
                        
                        Button {
                            
                        } label: {
                            RoundedRectangle(cornerRadius: 18)
                                .frame(height: 62)
                                .foregroundColor(Color.myGray)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(Color.white, lineWidth: 1.5)
                                    Text("출석하기")
                                        .foregroundColor(.white)
                                        .font(.title2.bold())
                                }
                        }
                        .frame(width: 338, height: 62)
                        .padding(.bottom ,10)
                        .offset(y: -80)
                        //FIXME: - Prototype용 코드 (출석하기 버튼이 비활성화 됐을 때 사용)
                        .disabled(true)
                        .onTapGesture { isAlert = true }
                    }
                }
            
            
            
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
            
            
            
        } // - VStack
        //        .animation(.linear(duration: 0.3), value: isAlert)
        .animation(.easeOut(duration: 0.3), value: isAlert)
        .transition(.opacity)
        .toolbarBackground(Material.ultraThinMaterial, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}



struct CheckMapView_Previews: PreviewProvider {
    static var previews: some View {
        CheckMapView()
    }
}

