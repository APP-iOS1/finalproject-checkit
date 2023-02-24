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
    /// 도로명 주소를 파라미터로 제공하면 [위도, 경도]를 반환하는 메서드 입니다.
    /// - Parameters:
    ///   - address: 도로명 주소를 입력합니다.
    ///   - completion: 도로명 주소를 입력하면 (latitue, longitude) (위도, 경도) 를 반환합니다.
    static func getCoding(address : String, completion : @escaping ([String]?) -> ()) {
        let url = "\(Bundle.main.object(forInfoDictionaryKey: "GEOCODING_URL") as? String ?? "")"
        let headers : HTTPHeaders = [
            "X-NCP-APIGW-API-KEY-ID" : "\(Bundle.main.object(forInfoDictionaryKey: "NAVER_API_KEY_ID") as? String ?? "")",
            "X-NCP-APIGW-API-KEY" : "\(Bundle.main.object(forInfoDictionaryKey: "NAVER_API_KEY") as? String ?? "")"
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
                for location in response.addresses {
                    //x값은 경도(longitude), y값은 위도(latitude)
                    completion([location.y, location.x])
                }
            case .failure(let error):
                print(error.localizedDescription)
                print(response.response?.statusCode)
                completion(nil)
            }
        }
    }
    
    static func getCoordinateFromAddress(address : String) async -> [String]? {
        return await withCheckedContinuation { continuation in
            GeoCodingService.getCoding(address: address) { result in
                continuation.resume(returning: result)
            }
        }
    }
}
