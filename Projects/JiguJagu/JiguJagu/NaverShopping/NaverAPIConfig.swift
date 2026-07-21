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
        get throws {
            try value(forKey: "NaverClientID",
                      placeholder: naverIDPlaceholder,
                      xcconfigName: "NAVER_CLIENT_ID")
        }
    }

    /// 네이버 개발자센터 애플리케이션의 Client Secret
    static var naverClientSecret: String {
        get throws {
            try value(forKey: "NaverClientSecret",
                      placeholder: naverSecretPlaceholder,
                      xcconfigName: "NAVER_CLIENT_SECRET")
        }
    }
}
