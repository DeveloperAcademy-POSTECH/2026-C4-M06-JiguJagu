//
//  NaverAPIConfig.swift
//  JiguJagu
//
//  Created by SIA on 7/21/26.
//

import Foundation

extension APIConfig {

    private static let naverIDPlaceholder     = "YOUR_NAVER_CLIENT_ID_HERE"
    private static let naverSecretPlaceholder = "YOUR_NAVER_CLIENT_SECRET_HERE"

    /// 네이버 개발자센터 애플리케이션의 Client ID
    static var naverClientID: String {
        naverValue(forKey: "NaverClientID",
                   placeholder: naverIDPlaceholder,
                   xcconfigName: "NAVER_CLIENT_ID")
    }

    /// 네이버 개발자센터 애플리케이션의 Client Secret
    static var naverClientSecret: String {
        naverValue(forKey: "NaverClientSecret",
                   placeholder: naverSecretPlaceholder,
                   xcconfigName: "NAVER_CLIENT_SECRET")
    }

    private static func naverValue(forKey key: String,
                                   placeholder: String,
                                   xcconfigName: String) -> String {
        guard
            let value = Bundle.main.object(forInfoDictionaryKey: key) as? String,
            !value.isEmpty,
            value != placeholder
        else {
            assertionFailure("""
            네이버 API 키(\(xcconfigName))가 설정되지 않았습니다.
            Secrets.xcconfig 의 \(xcconfigName) 값을 확인하고,
            Info.plist 에 \(key) = $(\(xcconfigName)) 가 있는지 확인하세요.
            """)
            return ""
        }
        return value
    }
}
