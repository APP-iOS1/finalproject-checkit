//
//  Group.swift
//  CheckIt
//
//  Created by 이학진 on 2023/01/31.
//

import Foundation

struct Group: Identifiable, Hashable {
    var id: String
    var name: String
    var invitationCode: String
    var image: String
    var hostID: String
    var description: String    
    var scheduleID: [String]
    var memberLimit: Int
    var isStop: Bool
    
    static var randomCode: String {
        let stringData = UUID().uuidString.suffix(8)
        let data = stringData.data (using: .utf8)
        
        var encode = data!.base64EncodedString()
        encode.removeLast()
        
        return encode
    }
    
    static let sampleGroup: Group = Group(id: "1",
                                          name: "허미니의 또구동아리",
                                          invitationCode: "ㅇㄴㅁㅇㅁㄴㅇ",
                                          image: "",
                                          hostID: "",
                                          description: "야구동아리입니다",
                                          scheduleID: [],
                                          memberLimit: 0,
                                          isStop: false
    )
    
    static func sortedGroup(_ groups: [Group], userId: String) -> [Group]{
        let hostGroups = groups.filter{ $0.hostID == userId }
        let notHostGroups = groups.filter{ $0.hostID != userId }
        return hostGroups + notHostGroups
    }
}
