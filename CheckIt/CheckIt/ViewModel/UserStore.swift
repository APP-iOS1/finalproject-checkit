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
    @Published var isProcessing: Bool = false
    @Published var isLoginError: Bool = false

    @Published var userDictionaryList: [String : String] = [:] //key uid, value nickname
    @Published var userNumberDictionaryList: [String : String] = [:]

    var userData: FirebaseAuth.User? = nil
    
    var isLogined: Bool = false
    
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
    
    
    func firebaseUserDelete(user: FirebaseAuth.User) async -> Error? {
        return await withCheckedContinuation { continuation in
            user.delete { error in
                continuation.resume(returning: error)
            }
        }
    }
    
    func unlinkKakaoAccount() async -> Error? {
        return await withCheckedContinuation { continuation in
            UserApi.shared.unlink { error in
                continuation.resume(returning: error)
            }
        }
    }
    
    
    //MARK: - Method(deleteUser)
    /// 회원탈퇴
    func deleteUser() async -> Bool {
        // 파이어베이스 유저 삭제
        guard let user = Auth.auth().currentUser else { return false }
        await deleteAllUserData(id: user.uid)
        if let error = await firebaseUserDelete(user: user) {
            return false
        }
        
        
        // 로그인 센터별 연결 끊기
        switch loginCenter {
        case .apple:
            break
        case .kakao:
            // 카카오 연결끊기
            if let error = await unlinkKakaoAccount() {
                return false
            }
        case .google:
            break
        default:
            return false
        }
        
        return true
    } // - deleteUser
    
    
    //MARK: - Method(startUserListener)
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
    } // - startUserListener
    
    //MARK: - Method(userListFetch)
    func fetchUserDictionaryList() {
        database.collection("User").getDocuments { snapshot, error in
            self.userDictionaryList.removeAll()
            if let snapshot {
                for document in snapshot.documents {
                    let docData = document.data()
                    let id: String = docData[UserConstants.id] as? String ?? ""
                    let name: String = docData[UserConstants.name] as? String ?? ""
                    let userNumber: String = docData["user_number"] as? String ?? ""
                    
                    self.userDictionaryList[id] = name
                    self.userNumberDictionaryList[id] = userNumber
                }
            }
        }
    }
    
    //MARK: - Method(userUpdate)
    func userUpdate(_ user: [String:Any]) {
        let id = user["id"] as? String ?? ""
        let email = user["email"] as? String ?? ""
        let name = user["name"] as? String ?? ""
        let groupId = user["group_id"] as? [String] ?? []
        let loginCenter = user["login_center"] as? String ?? ""
        let userNumber = user["user_number"] as? String ?? ""
       
        self.user = User(id: id, email: email, name: name, userNumber: userNumber, groupID: groupId)
    } // - userUpdate
    
    
    
    
    
    func isUserInDatabaseWithKakao(uid: String) async -> Bool{
        return await withCheckedContinuation { continuation in
            isUserInDatabaseWithKakaoCompletionHandler(uid: uid) { result in
                continuation.resume(returning: result)
                
            }
        }
    }
    
    
    
    //MARK: - Method(loginWithKakao)
    /// 카카오로 로그인
    func loginWithKakao() async {
        guard let firebaseToken = await KakaoLoginStore().returnFirebaseToken() else { return }
        do {
            try await Auth.auth().signIn(withCustomToken: firebaseToken)
            guard let user = Auth.auth().currentUser else { return }

            self.userData = user
            let result = await isUserInDatabaseWithKakao(uid: "\(String(describing: user.uid))")

            // 회원가입
            if !result {
                DispatchQueue.main.async {
                    self.isFirstLogin = true
                }
                
                
                let userNumber = await userNumberGenerator()
                
                let newUser: User = .init(id: userData?.uid ?? "N/A", email: userData?.email ?? "N/A", name: userData?.displayName ?? "N/A", userNumber: userNumber, groupID: [])
                self.addUser(user: newUser)
            }
            await self.fetchUser(user.uid)
            self.toggleLoginState()
        } catch {
            DispatchQueue.main.async {
                self.isLoginError = true
            }
            print("\(error.localizedDescription)")
            return
        }
//            Auth.auth().signIn(withCustomToken: firebaseToken) { user, error in
//                if let error {
//                    print("\(error.localizedDescription)")
//                    return
//                }
//
//                self.userData = user?.user
//                self.isUserInDatabaseWithKakao(uid: "\(String(describing: user?.user.uid ?? ""))", completion: { result in
//                    Task {
//                        await self.fetchUser(user?.user.uid ?? "")
//                    }
//                    if !result {
//                        self.addUser(userData: self.userData)
//                        DispatchQueue.main.async {
//                            self.isFirstLogin = true
//                        }
//                        return
//                    }
//                    self.toggleLoginState()
//
//                })
//            }
        
    } // - loginWithKakao
    
    //MARK: - Method(loginWithCredential)
    /// 구글, 애플 로그인
    func loginWithCredential(_ result: Result<ASAuthorization, Error>? = nil) async {
        var credential: AuthCredential?
        var name: String?
        switch loginCenter {
        case .apple:
            guard let result else { return }
            let credentialAndName = await AppleLoginStore().logIn(result: result)
            credential = credentialAndName.0
            name = personNameComponentsToStringName(credentialAndName.1)
            
        case .google:
            credential = await GoogleLoginStore().signIn()
        default:
            return
        }
        guard let credential else { return }
        await signInWithCredential(credential: credential, name: name)
        
    } // - loginWithCredential
    
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
    
    //MARK: - Method(isUserInDatabaseWithKakao)
    func isUserInDatabaseWithKakaoCompletionHandler(uid: String, completion: @escaping (Bool) -> ()) {
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
    } // - isUserInDatabaseWithKakao
    
    
    //MARK: - Async Method
    //MARK: - Method(signIn)
    /// Firebase 로그인 메서드입니다. credential을 제3자(애플, 구글)로부터  파라미터로 제공받아 파이어베이스 로그인에 연결합니다.
    /// Return (로그인 성공 여부)
    func signInWithCredential(credential: AuthCredential?, name: String?) async -> Bool {
        guard let credential = credential else { return false }
        let (authResult, error) = await firebaseSignIn(credential: credential)
        if let error {
            DispatchQueue.main.async {
                self.isLoginError = true
            }
            print("\(error.localizedDescription)")
            return false
        }
        guard let authResult else { return false }
        self.userData = authResult.user
        
        let isUser = await isUserInDatabase(email: userData?.email ?? "N/A")
        // 회원가입
        if !isUser {
            // 애플 로그인인 경우 회원가입 시에만 이름을 받습니다.
            let isAppleLogin = (loginCenter == .apple  && name != nil)
            let userNumber = await userNumberGenerator()
            print(userNumber)
            let newUser: User = .init(id: userData?.uid ?? "N/A", email: userData?.email ?? "N/A", name: isAppleLogin ? name! : userData?.displayName ?? "N/A", userNumber: userNumber, groupID: [])
            self.addUser(user: newUser)
            
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
            let userNumber = data["user_number"] as? String ?? ""
            let loginCenter = data["login_center"] as? String ?? ""
            
            let user = User(id: id,
                            email: email,
                            name: name,
                            userNumber: userNumber,
                            groupID: groupId)
            
            
            DispatchQueue.main.async {
                self.user = user
                self.loginCenter = LoginCenter(rawValue: loginCenter)
            }
        } catch {
            DispatchQueue.main.async {
                self.isLoginError = true
            }
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
    func addUser(user: User) {
        database.collection("User")
            .document("\(user.id)")
            .setData([
                "id" : user.id ,
                "name" : user.name,
                "email" : user.email,
                "user_number" : user.userNumber,
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
    
    
    //MARK: - Method(deleteAllUserData)
    /// 회원탈퇴 시 유저의 모든 데이터를 db에서 삭제합니다.
    /// Parameter id - 삭제할 user의 id입니다.
    func deleteAllUserData(id: String) async {
        do {
//            // 유저의 출석부를 모두 삭제합니다.
//            let snapshot = try await database.collectionGroup("Attendance")
//                .order(by: "schedule_id")
//                .whereField("id", isEqualTo: "\(id)")
//                .getDocuments()
//
//
//            for document in snapshot.documents {
//                try await database.document("\(document.documentID)")
//                    .delete()
//            }
            
            // 유저의 사용자 정보를 삭제합니다.
            let userSnapshot = try await database.collection("User")
                .document("\(id)").delete()
            
            
//            // 유저가 방장인 그룹을 모두 삭제합니다.
//            let groupSnapshot = try await database.collection("Group").whereField("host_id", isEqualTo: "\(id)").getDocuments()
//            for document in groupSnapshot.documents {
//                try await database.document("\(document.documentID)")
//                    .delete()
//            }
//
//            // 유저가 속한 모든 그룹을 삭제합니다. (멤버리스트 삭제)
//
            
        }
        catch { print("catch Error: \(error.localizedDescription)"); return }
    } // - deleteAllUserData
    
    
    
    
    //MARK: - Method(changeUserName)
    /// user의 이름을 변경하는 메서드입니다.
    /// - Parameter name : user가 변경할 이름
    func changeUserName(name: String) {
        guard let user = self.user else { return }
        self.user?.name = name
        updateUser(user: self.user!)
    } // - changeUserName
    
    
    //MARK: - Method(resetData)
    func resetData() {
        user = nil
        //loginState = .logout
        loginCenter = nil
        isPresentedLoginView = true
        isFirstLogin = false
        isProcessing = false
        
        userData = nil
        isLogined = false
    } // - resetData
    
    func userNumberGenerator() async -> String {
        var result = ""
        // 만번이상 반복했으면 반복문 탈출
        var count = 0
        while count < 10001 {
            result = fourDigitNumberGenerator()
            let isUserNumber = await isUserNumber(result)
            if !isUserNumber {
                break
            }
            count += 1
        }
        
        do {
            try await database.collection("UserNumber").document(result)
                .setData([:])
        } catch {
            print("\(error.localizedDescription)")
        }
        
        
        return result
    }
    
    
    //
    func fourDigitNumberGenerator() -> String {
            var number: String = ""
            for _ in 0...3 {
                number += "\(Int.random(in: Range(0...9)))"
            }
            return number
        }
    
    
    
    //MARK: - Method(isUserNumber)
    /// 유저 고유 번호가 컬렉션에 이미 생성 됐는지 확인하는 메서드입니다.
    func isUserNumber(_ userNumber: String) async -> Bool {
        do {
            let document = try await database.collection("UserNumber")
            .document(userNumber).getDocument()
            
            // 아직 생성되지 않음
            if !document.exists {
                return false
            }
            
            return true
        } catch {
            print("\(error.localizedDescription)")
        }
        
        return true
    } // - isUserNumber
    
}





//MARK: - Method(personNameComponentsToStringName)
/// personNameComponents로 선언되어 있는 이름을 String 타입으로 변환하여 반환하는 메서드입니다.
func personNameComponentsToStringName(_ personNameComponents: PersonNameComponents?) -> String {
    guard let personNameComponents else { return "" }
    var result: String = ""
    if let familyName = personNameComponents.familyName {
        result += familyName
    }
    if let middleName = personNameComponents.middleName {
        result += middleName
    }
    if let givenName = personNameComponents.givenName {
        result += givenName
    }
    
    return result
} // - personNameComponentsToStringName
