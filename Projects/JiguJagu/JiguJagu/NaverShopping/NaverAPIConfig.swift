//
//  NaverAPIConfig.swift
//  JiguJagu
//
//  Created by SIA on 7/21/26.
//

import Foundation

/// API 키 설정 관련 에러
enum APIConfigError: LocalizedError {

    case missingNaverKey(key: String, xcconfigName: String)

    var errorDescription: String? {
        switch self {
        case let .missingNaverKey(key, xcconfigName):
            return """
            네이버 API 키(\(xcconfigName))가 설정되지 않았습니다.
            Secrets.xcconfig 의 \(xcconfigName) 값을 확인하고,
            Info.plist 에 \(key) = $(\(xcconfigName)) 가 있는지 확인하세요.
            """
        }
    }
}

extension APIConfig {

    private static let naverIDPlaceholder     = "YOUR_NAVER_CLIENT_ID_HERE"
    private static let naverSecretPlaceholder = "YOUR_NAVER_CLIENT_SECRET_HERE"

    /// 네이버 개발자센터 애플리케이션의 Client ID
    static var naverClientID: String {
        get throws {
            try naverValue(forKey: "NaverClientID",
                           placeholder: naverIDPlaceholder,
                           xcconfigName: "NAVER_CLIENT_ID")
        }
    }

    /// 네이버 개발자센터 애플리케이션의 Client Secret
    static var naverClientSecret: String {
        get throws {
            try naverValue(forKey: "NaverClientSecret",
                           placeholder: naverSecretPlaceholder,
                           xcconfigName: "NAVER_CLIENT_SECRET")
        }
    }

    /// 키가 없거나 placeholder 그대로면 APIConfigError 를 throw 한다.
    /// assertionFailure 와 달리 Release 에서도 호출부에서 처리 가능
    private static func naverValue(forKey key: String,
                                   placeholder: String,
                                   xcconfigName: String) throws -> String {
        guard
            let value = Bundle.main.object(forInfoDictionaryKey: key) as? String,
            !value.isEmpty,
            value != placeholder
        else {
            throw APIConfigError.missingNaverKey(key: key, xcconfigName: xcconfigName)
        }
        return value
    }
}
