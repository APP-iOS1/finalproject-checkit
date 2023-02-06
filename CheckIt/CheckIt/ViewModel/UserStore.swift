//
//  UserStore.swift
//  CheckIt
//
//  Created by 이학진 on 2023/01/31.
//

import Firebase
import FirebaseFirestore
import GoogleSignIn
import FirebaseAuth
import KakaoSDKUser
import KakaoSDKAuth
import AuthenticationServices

class UserStore: ObservableObject {
    let database = Firestore.firestore()
    
    @Published var user: User? = nil
    @Published var loginState: LoginState = .logout
    @Published var loginCenter: LoginCenter? = nil
    @Published var isPresentedLoginView: Bool = true
    @Published var isFirstLogin: Bool = false
    
    var userData: FirebaseAuth.User? = nil
    
    private var listener: ListenerRegistration?
    
    enum LoginState {
        case login
        case logout
    }
    
    enum LoginCenter: String {
        case apple = "apple"
        case kakao = "kakao"
        case google = "google"
    }
    
    /// 회원탈퇴
    func deleteUser() -> Bool {
        switch loginCenter {
        case .apple:
            return false
        case .kakao:
            UserApi.shared.unlink { error in
                if let error = error {
                    print("\(error.localizedDescription)")
                    return
                }
            }
            break
        case .google:
            
            return false
            
        default:
            return false
        }
        
        // 파이어베이스 DB에서 회원 정보 삭제
        return false
        
    }
    
    func startUserListener(_ uid: String) {
        self.listener = database.collection("User").whereField("id", isEqualTo: uid)
            .addSnapshotListener(includeMetadataChanges: true) { querySnapshot, error in
            print("유저 리스너 호출")
            
            guard let snapshot = querySnapshot else {
                print("fetching user error: \(error!)")
                return
            }
            
            snapshot.documentChanges.forEach { diff in
                switch diff.type {
                case .added:
                    print("유저 추가")
                case .modified:
                    print("유저 수정")
                    self.userUpdate(diff.document.data())
                case .removed:
                    print("유저 제거")
                }
            }
        }
    }
    
    func userUpdate(_ user: [String:Any]) {
        let id = user["id"] as? String ?? ""
        let email = user["email"] as? String ?? ""
        let name = user["name"] as? String ?? ""
        let groupId = user["group_id"] as? [String] ?? []
        let loginCenter = user["login_center"] as? String ?? ""
        
        self.user = User(id: id, email: email, name: name, groupID: groupId)
    }
    
    /// 카카오로 로그인
    func loginWithKakao() {
//        // 로그인 시도한 내역이 있음
//        if AuthApi.hasToken() {
//            // Firebase DB에 있는지 확인
//            UserApi.shared.me { user, error in
//                user?.id
//            }
//            //없으면 간편 회원가입
//
//            return
//        }
        
        // 시도 내역이 없음
        // 같은 이메일로 로그인 시도 내역이 있는지 확인
        // isUser
        // 있으면 로그인 불가
//        guard let firebaseToken = KakaoLoginStore().returnFirebaseToken()
//        else { return }
        
        KakaoLoginStore().returnFirebaseToken { firebaseToken in
            
            guard let firebaseToken else { return }
            print(type(of:firebaseToken))
            
            Auth.auth().signIn(withCustomToken: firebaseToken) { user, error in
                if let error {
                    print("\(error.localizedDescription)")
                    return
                }
                
                self.userData = user?.user
                self.isUserInDatabaseWithKakao(uid: "\(String(describing: user?.user.uid ?? ""))", completion: { result in
                    print("isFirstLoginWithKakao:",result)
                    Task {
                        await self.fetchUser(user?.user.uid ?? "")
                    }
                    if !result {
                        self.addUser(userData: self.userData)
                        DispatchQueue.main.async {
                            self.isFirstLogin = true
                        }
                        return
                    }
                    self.toggleLoginState()
                    
                })
                print("로그인 성공")
            }
        }
        
        
       
        
        
        
    }
    
    /// 구글, 애플 로그인
    func loginWithCredential(_ result: Result<ASAuthorization, Error>? = nil) async {
        var credential: AuthCredential?
        switch loginCenter {
        case .apple:
            guard let result else { return }
            credential = await AppleLoginStore().logIn(result: result)
        case .google:
            credential = await GoogleLoginStore().signIn()
        default:
            return
        }
        guard let credential else { return }
        await signInWithCredential(credential: credential)
        
    }
        
        //MARK: - CompletionHandler Method
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
    
    func isUserInDatabaseWithKakao(uid: String, completion: @escaping (Bool) -> ()) {
        database.collection("User").whereField("id", isEqualTo: "\(uid)")
            .getDocuments { snapshot, error in
                if let error {
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
    }
        
        
        //MARK: - Async Method
        //MARK: - Method(signIn)
        /// Firebase 로그인 메서드입니다. credential을 제3자(애플, 구글)로부터  파라미터로 제공받아 파이어베이스 로그인에 연결합니다.
        /// Return (로그인 성공 여부)
        func signInWithCredential(credential: AuthCredential?) async -> Bool {
            guard let credential = credential else { return false }
            let (authResult, error) = await firebaseSignIn(credential: credential)
            if let error {
                print("\(error.localizedDescription)")
                return false
            }
            guard let authResult else { return false }
            self.userData = authResult.user
            
            let isUser = await isUserInDatabase(email: userData?.email ?? "N/A")
            print(isUser, userData?.email)
            //FIXME: 회원가입 -> 간편 회원가입 뷰로 넘겨줘야 함
            if !isUser {
                addUser(userData: self.userData)
                DispatchQueue.main.async {
                    self.isFirstLogin = true
                }
            }
            await fetchUser(self.userData?.uid ?? "N/A")
            self.toggleLoginState()
            return true
        } // - signIn
        
        
        
        
        //MARK: - Method(firebaseSignIn)
        /// Firebase에서 제공되는  Completion Handler로 구현된 signIn 함수를 Async로 변환한 메서드입니다.
        func firebaseSignIn(credential: AuthCredential) async -> (AuthDataResult?, Error?) {
            return await withCheckedContinuation { continuation in
                Auth.auth().signIn(with: credential) { authResult, error in
                    continuation.resume(returning: (authResult, error))
                }
            }
        } // - firebaseSignIn
        
        
        
        //MARK: - Method(fetchUser)
        /// user를 db로부터 불러오는 메서드입니다.
        func fetchUser(_ uid: String) async {
            do {
                print("user.id:",uid)
                let querySnapshot = try await database.collection("User").document(uid).getDocument()
                
                guard let data = querySnapshot.data() else { print("data leak"); return }
                
                let id = data["id"] as? String ?? ""
                let email = data["email"] as? String ?? ""
                let name = data["name"] as? String ?? ""
                let groupId = data["group_id"] as? [String] ?? []
                let loginCenter = data["login_center"] as? String ?? ""
                
                let user = User(id: id,
                                email: email,
                                name: name,
                                groupID: groupId)
                
                print("파베에서 가져온 user: \(user)")
                
                DispatchQueue.main.async {
                    self.user = user
                    self.loginCenter = LoginCenter(rawValue: loginCenter)
                }
            } catch {
                print("fetchUser error: \(error.localizedDescription)")
            }
        } // - fetchUser
        
        
        
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
                DispatchQueue.main.async {
                    self.loginState = .logout
                    self.isPresentedLoginView = true
                    
                }
            case .logout:
                DispatchQueue.main.async {
                    self.loginState = .login
                    if !self.isFirstLogin {
                        self.isPresentedLoginView = false
                    }
                }
            }
        } // - toggleLoginState
        
        
        //MARK: - Method(signOut)
        /// Firebase 로그아웃 메서드입니다.
        func signOut() {
            do {
                // 파이어베이스 로그아웃
                try Auth.auth().signOut()
                self.toggleLoginState()
                self.userData = nil
                
                // 제3자 로그아웃
                switch loginCenter {
                case .apple:
                    break
                case .kakao:
                    UserApi.shared.logout { error in
                        if let error {
                            print("로그아웃 에러: \(error.localizedDescription)")
                            return
                        }
                    }
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
                    "id" : user.uid ,
                    "name" : user.displayName ?? "N/A",
                    "email" : user.email ?? "N/A",
                    "group_id" : [],
                    "login_center": self.loginCenter?.rawValue
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
                    "login_center": self.loginCenter?.rawValue
                ])
        } // - updateUser
        
        //MARK: - Method(changeUserName)
        /// user의 이름을 변경하는 메서드입니다.
        /// - Parameter name : user가 변경할 이름
        func changeUserName(name: String) {
            guard let user = self.user else { return }
            self.user?.name = name
            updateUser(user: self.user!)
        } // - changeUserName
    
    
    /// 입력받은 uid를 기반으로 유저의 이름을 가져오는 메소드입니다.
    /// - Parameter uid: 이름을 가져올 유저의 uid
    /// - Returns 유저의 이름
    func getUserName(_ uid: String) async -> String {
        let defaultName: String = "N/A"
        do {
            let document = try await database.collection("User").document(uid).getDocument()
            
            guard let data = document.data() else { return defaultName}
            let name = data["name"] as? String ?? defaultName
            return name
            
        } catch {
            print("getUserName error \(error.localizedDescription)")
            return defaultName
        }
    }
}
    
    

