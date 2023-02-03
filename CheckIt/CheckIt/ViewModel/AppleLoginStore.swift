//
//  AppleLoginStore.swift
//  CheckIt
//
//  Created by sole on 2023/02/03.
//

import AuthenticationServices
import CryptoKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class AppleLoginStore {
    func logIn(result: Result<ASAuthorization, Error>) -> AuthCredential? {
        switch result {
        case .success(let authResult):
            guard let idCredential = authResult.credential as? ASAuthorizationAppleIDCredential, let identityToken = idCredential.identityToken, let identityTokenString = String(data: identityToken, encoding: .utf8) else { return nil}
            let nonce = AppleLoginStore().sha256(AppleLoginStore().randomNonceString())
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: identityTokenString, rawNonce: nonce)
            return credential
        case .failure(let error):
            print("\(error.localizedDescription)")
            return nil
        }

    }
    
    func logOut() {
    }
    
    
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    
    
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}
