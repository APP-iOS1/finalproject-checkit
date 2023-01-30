//
//  GeoCodingService.swift
//  Check_It
//
//  Created by 류창휘 on 2023/01/05.
//
import Foundation
import Alamofire

/// Naver GeoCoding API 서비스입니다.
class GeoCodingService {
    func getCoding(address : String, completion : @escaping ([String]) -> ()) {
        let url = "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode"
        let headers : HTTPHeaders = [
            "X-NCP-APIGW-API-KEY-ID" : "",
            "X-NCP-APIGW-API-KEY" : ""
        ]
        let parameters : Parameters = [
            "query" : "\(address)"
        ]
        AF.request(url,
                   method: .get,
        parameters: parameters,
                   encoding: URLEncoding.default,
        headers: headers)
        .validate()
        .responseDecodable(of: GeoCodingResponse.self) { response in
            switch response.result {
            case .success(let response):
                print("DEBUG >> Success \(response)")
                for location in response.addresses {
                    //x값은 경도, y값은 위도
                    print(location.x, "x값")
                    print(location.y, "y값")
//                    completion(["x" : location.x, "y" : location.y])
                    completion([location.x, location.y])
                }
            case .failure(let error):
                print(error.localizedDescription)
                print(response.response?.statusCode)
                completion(["오류", "오류"])
            }
        }
    }
}
