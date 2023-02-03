//
//  UserStore.swift
//  CheckIt
//
//  Created by 이학진 on 2023/01/31.
//

import Firebase
import FirebaseFirestore
import SwiftUI
import UIKit
import GoogleSignIn
import FirebaseAuth


class UserStore: ObservableObject {
     let database = Firestore.firestore()
     
     @Published var user: User? = nil
     @Published var loginState: LoginState = .logout
     @Published var loginCenter: LoginCenter? = nil
     @Published var isPresentedLoginView: Bool = true
     
     // 사용자 이름 수정 가능하도록
     @Published var userName: String = ""
     @Published var userData: FirebaseAuth.User? = nil
     
     enum LoginState {
          case login
          case logout
     }
     
     enum LoginCenter {
          case apple
          case kakao
          case google
     }
     
//     func kakaoLoginWithFirebase() {
//          KakaoLoginStore().signIn()
//          print("!")
//          UserApi.shared.me() { user, error in
//               if let error = error {
//                    print("\(error.localizedDescription)")
//                    return
//               }
//               print("kakao Login \(user?.kakaoAccount)")
//               Auth.auth().createUser(withEmail: user?.kakaoAccount?.email ?? "N/A", password: "\(String(describing: user?.id))") { authresult, error in
//                    if let error = error {
//                         print("\(error.localizedDescription)")
//                         return
//                    }
//
//                    print(authresult?.user.email)
//               }
//
//          }
//     }
     
     //MARK: - Method(isUserInDatabaseCompletionHandler)
     /// 유저가 파이어베이스 스토어에 등록됐는지 확인하는 과정을 컴플리션 핸들러로 구현한 메서드입니다.
     func isUserInDatabaseCompletionHandler(email: String, completion: @escaping (Bool) -> ()) {
          database.collection("User").whereField("email", isEqualTo: "\(email)")
               .getDocuments { snapshot, error in
                    if let error = error {
                         print("\(error.localizedDescription)")
                         completion(false)
                         return
                    }
                    
                    if snapshot == nil || snapshot?.documents == [] {
                        print(snapshot?.documents ?? [])
                         completion(false)
                         return
                    }
                    
                    completion(true)
                    
               }
     } // - isUserInDatabaseCompletionHandler
     
     
     //MARK: - isUserInDatabase
     /// 유저가 파이어베이스 스토어에 등록됐는지 확인하는 과정을 Async로 구현한 메서드입니다 .
     func isUserInDatabase(email: String) async -> Bool {
          return await withCheckedContinuation { continuation in
               isUserInDatabaseCompletionHandler(email: email) { result in
                    continuation.resume(returning: result)
               }
          }
     } // - isUserInDatabase
     
     //MARK: - toggleLoginState
     ///Login State를 toggle 하는 메서드입니다.
     func toggleLoginState() {
          switch loginState {
          case .login:
               self.loginState = .logout
               DispatchQueue.main.async {
                    self.isPresentedLoginView = true
               }
          case .logout:
               self.loginState = .login
               DispatchQueue.main.async {
                    self.isPresentedLoginView = false
               }
          }
     } // - toggleLoginState
     
     //MARK: - Method(signIn)
     /// Firebase 로그인 메서드입니다. credential을 제3자(애플, 카카오, 구글)로부터  파라미터로 제공받아 파이어베이스 로그인에 연결합니다.
     func signInCompletionHandler(credential: AuthCredential?, completion: @escaping (FirebaseAuth.User?) -> ()) {
          
          guard let credential = credential else { completion(nil); return }
         
         //FIXME: async로 변경해야 함 (completion Handler 안에 async 돌리는 경우 잘 없음)
          Auth.auth().signIn(with: credential) { [unowned self] authResult, error in
//              var isUser: Bool = true
               if let error = error {
                    print("\(error.localizedDescription)")
                    return
               }
               
               //FIXME: memory leak (guard case let self.userData = authResult?.user else{return}시 발생
               self.userData = authResult?.user
               
               
                  
              Task {
                  var isUserTemp = await self.isUserInDatabase(email: userData?.email ?? "N/A")
                  if !isUserTemp {
                       addUser(userData: authResult?.user)
                  }
              }
               
//              print(isUserTemp)
//               print(userData?.email, "Firebase Login")
               
//               // 회원이 아니면 회원가입 (db에 정보 업로드)
//               if !isUserTemp {
//                    addUser(userData: authResult?.user)
//               }
              
              fetchUserData(id: userData?.uid ?? "") { user in
                  self.user = user
              }
               self.toggleLoginState()
               completion(authResult?.user)
          }
     } // - signIn
     
     //MARK: - Method(signIn)
     /// Firebase 로그인 메서드입니다. credential을 제3자(애플, 카카오, 구글)로부터  파라미터로 제공받아 파이어베이스 로그인에 연결합니다.
     func signIn(credential: AuthCredential?) async -> FirebaseAuth.User? {
          return await withCheckedContinuation { continuation in
               signInCompletionHandler(credential: credential) { result in
                    continuation.resume(returning: result)
               }
          }
     } // - signIn
     
    //MARK: - Method(fetchUserData)
    /// db에 있는 userData를 불러오는 메서드입니다.
    func fetchUserData(id: String, completion: @escaping (User) -> ()) {
        var user: User = .init(id: "", email: "", name: "", groupID: [])
        database.collection("User")
            .document("\(id)")
            .getDocument { document, error in
                if let error = error {
                    print("\(error.localizedDescription)")
                    return
                }
                
                guard let document else { return }
                user.id = document["id"] as? String ?? "N/A"
                user.email = document["email"] as? String ?? "N/A"
                user.name = document["name"] as? String ?? "N/A"
                user.groupID = document["groupID"] as? [String] ?? []
                completion(user)
            }
        completion(user)
    } // - fetchUserData
    
     //MARK: - Method(returnUserData)
     /// 유저 데이터를 반환하는 메서드입니다. -> 삭제
     func returnUserData() -> User? {
          if loginState == .logout {
               print("로그인 진행 필요")
               return nil
          }
          
          return self.user
     } // - fetchUserData
    
    
     
     
     //MARK: - Method(signOut)
     /// Firebase 로그아웃 메서드입니다.
     func signOut() {
          let firebaseAuth = Auth.auth()
          do {
               // 파이어베이스 로그아웃
               try firebaseAuth.signOut()
               self.toggleLoginState()
               self.userData = nil
               
               // 제3자 로그아웃
               switch loginCenter {
               case .apple:
                    break
               case .kakao:
//                    UserApi.shared.logout { error in
//                         if let error = error {
//                              print("\(error.localizedDescription)")
//                              return
//                         }
//                         print("kakao 로그아웃 완료")
//                    }
                    break
               case .google:
                    GIDSignIn.sharedInstance.signOut()
                    break
               case .none:
                    print("Error! 로그인 상태가 아닙니다. / 로그인 센터가 없습니다.")
                    break
               }
               
               print("Firebase Logout")
          } catch {
               print("\(error.localizedDescription)")
          }
     } // - signOut
     
     
     
     //MARK: - Method(addUser)
     /// db에 새로운 User 정보를 추가하는 메서드입니다.
     func addUser(userData: FirebaseAuth.User?) {
          guard let user = userData else { return }
          database.collection("User")
               .document("\(user.uid)")
               .setData([
                    "id" : user.uid ?? "N/A",
                    "name" : user.displayName,
                    "email" : user.email ?? "N/A",
                    "group_id" : [],
               ])
     } // - addUser
     
     //MARK: - Method(updateUser)
     /// db에 있는 유저 정보를 갱신하는 메서드입니다.
     func updateUser(user: User) {
          database.collection("User")
               .document("\(user.id)")
               .setData([
                    "id" : user.id,
                    "name" : user.name,
                    "email" : user.email,
                    "group_id" : user.groupID,
               ])
     } // - updateUser
     
     //MARK: - Method(changeUserName)
     /// user의 이름을 변경하는 메서드입니다.
     /// - Parameter name : user가 변경할 이름
     func changeUserName(name: String) {
          guard let user = self.user else { return }
          self.user?.name = name
          
          updateUser(user: user)
     }
     
}


//MARK: - GoogleLoginStore
/// 구글 로그인 관련 로직
class GoogleLoginStore {
     
     //MARK: - Method(signIn Async)
     /// 구글 로그인 함수입니다.
     func signIn() async -> AuthCredential? {
          return await withCheckedContinuation { continuation in
               signInCompletionHandler { result in
                    continuation.resume(returning: result)
               }
          }
          
     }
     
     
     func restorePreviousSignIn() {
          
     }
     
     //MARK: - Method(signIn)
     /// 구글 로그인을 Completion Handler로 구현한 메서드입니다.
     func signInCompletionHandler(completion: @escaping (AuthCredential?) -> (Void)) {
          
          //FIXME: 로그인 한 내역이 있는 경우
          if GIDSignIn.sharedInstance.hasPreviousSignIn() {
               GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
                    if let error = error {
                         print("\(error.localizedDescription)")
                         completion(nil)
                         return
                    }
                    guard
                         let authentication = user?.authentication,
                         let idToken = authentication.idToken
                    else {
                         completion(nil)
                         return
                    }
                    let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                                   accessToken: authentication.accessToken)
                    completion(credential)
                    print("로그인 내역이 있습니다")
                    
               }
               return
          }
          
          guard let clientID = FirebaseApp.app()?.options.clientID else { return }
          let config = GIDConfiguration(clientID: clientID)
          DispatchQueue.main.async {
               guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
               guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
               
               GIDSignIn.sharedInstance.signIn(with: config, presenting: rootViewController) { [unowned self] user, error in
                    if let error = error {
                         print("\(error.localizedDescription)")
                         completion(nil)
                         return
                    }
                    print("\(user?.profile?.email)")
                    guard
                         let authentication = user?.authentication,
                         let idToken = authentication.idToken
                    else {
                         completion(nil)
                         return
                    }
                    let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                                   accessToken: authentication.accessToken)
                    
                    completion(credential)
               }
          }
     } // - signInCompletionHandler
     
     
     //MARK: - Method(signOut)
     /// 구글 로그아웃 함수입니다.
     func signOut() {
          GIDSignIn.sharedInstance.signOut()
     } // - signOut
}



////MARK: - Class(KakaoLoginStore)
//class KakaoLoginStore {
//     
//     func signInCompletionHandler() {
//          // 카카오톡 실행 가능 여부 확인
//          if (UserApi.isKakaoTalkLoginAvailable()) {
//               UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
//                    if let error = error {
//                         print("\(error.localizedDescription)")
//                         return
//                    }
//                    print("loginWithKakaoTalk() success.")
//                    
//                    //do something
//                    _ = oauthToken
//                    print("\(oauthToken)")
//                    
//                    
//                    
//               }
//          } else {
//               //TODO: 카카오톡 설치 후 시도하라는 알럿 필요
//               print("카카오톡 실행 불가")
//          }
//          
//          
//     }
//     
//     func signIn() {
//          // 이미 로그인 된 경우
//          if (AuthApi.hasToken()) {
//               UserApi.shared.accessTokenInfo { (accessTokenInfo, error) in
//                    if let error = error {
//                         if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true  {
//                              //로그인 필요
//                              print("로그인이 필요합니다")
//                              print("\(error.localizedDescription)")
//                              if (UserApi.isKakaoTalkLoginAvailable()) {
//                                   UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
//                                        if let error = error {
//                                             print("\(error.localizedDescription)")
//                                             return
//                                        }
//                                        print("loginWithKakaoTalk() success.")
//                                        
//                                        //do something
//                                        _ = oauthToken
//                                        print(oauthToken?.accessToken)
//                                        
//                                   }
//                              } else {
//                                   //TODO: 카카오톡 설치 후 시도하라는 알럿 필요
//                                   print("카카오톡 실행 불가")
//                              }
//                              return
//                              
//                         }
//                         else {
//                              //기타 에러
//                              print("\(error.localizedDescription)")
//                              
//                         }
//                    }
//                    else {
//                         //토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
//                         print(accessTokenInfo?.expiresIn)
//                    }
//               }
//               return
//          }
//          //FIXME: 불가능하면 알럿 띄워줘야 함.
//          // 카카오톡 실행 가능 여부 확인
//          else if (UserApi.isKakaoTalkLoginAvailable()) {
//               UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
//                    if let error = error {
//                         print("\(error.localizedDescription)")
//                         return
//                    }
//                    print("loginWithKakaoTalk() success.")
//                    
//                    //do something
//                    _ = oauthToken
//                    print(oauthToken?.accessToken)
//                    
//               }
//          } else {
//               //TODO: 카카오톡 설치 후 시도하라는 알럿 필요
//               print("카카오톡 실행 불가")
//          }
//          
//     }
//     func signOut() {
//          UserApi.shared.logout { error in
//               return
//          }
//     }
//}



//MARK: - Test Views
struct GoogleLogin1: View {
     @StateObject var user = UserStore()
     var body: some View {
          VStack {
               Button(action:  {
                    Task {
                         guard let credential = await GoogleLoginStore().signIn() else { return }
                         user.loginCenter = .google
                         await user.signIn(credential: credential)
                    }
               }){ Text("로그인") }
               Button(action: {
                    user.signOut()
               }) { Text("로그아웃") }
               Button(action: {}) { Text("유저 데이터 불러오기") }
               
          }
     }
}


