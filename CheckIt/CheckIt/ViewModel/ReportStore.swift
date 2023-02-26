//
//  ReportStore.swift
//  CheckIt
//
//  Created by 이학진 on 2023/02/26.
//

import Foundation
import Firebase

enum ReportError: String, Error {
    case reportError = "신고가 실패하였습니다."
}

// Singleton
class ReportManager {
    static let shared = ReportManager()
    private let database = Firestore.firestore()
    
    private init() { }
    
    /// 유저가 동아리를 신고 하는 메소드
    /// - Parameter report: 신고 인스턴스
    /// - Returns:  Result<String, ReportError>:  성공시 성공 메시지, 실패시 에러를 반환함
    func reportGroup(_ report: Report) async -> Result<String, ReportError> {
        do {
            try await ReportManager.shared.database.collection("Report")
                .document(report.id)
                .setData([
                    "id": report.id,
                    "group_id": report.groupId,
                    "repoter_id": report.reporterId,
                    "content": report.content,
                    "date": report.date
                ])
            return .success(Constants.reportSuccessMessage)
        } catch {
            print("error: \(error.localizedDescription)")
            return .failure(.reportError)
        }
    }
}

private enum Constants {
    static let reportSuccessMessage: String = "신고가 완료되었습니다."
}
