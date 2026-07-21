//
//  APIConfig.swift
//  JiguJagu
//
//  Created by SIA on 7/20/26.
//

import Foundation

/// API 키 설정 관련 에러
/// - 키 누락 시 assertionFailure(Debug 전용) 대신 throw 하여
///   Release 환경에서도 호출부에서 처리할 수 있게 한다.
enum APIConfigError: LocalizedError {

    case missingKey(key: String, xcconfigName: String)

    var errorDescription: String? {
        switch self {
        case let .missingKey(key, xcconfigName):
            return """
            API 키(\(xcconfigName))가 설정되지 않았습니다.
            Secrets.xcconfig 의 \(xcconfigName) 값을 확인하고,
            Info.plist 에 \(key) = $(\(xcconfigName)) 가 있는지 확인하세요.
            """
        }
    }
}

enum APIConfig {

    /// 아직 키를 채우지 않았을 때의 플레이스홀더 값
    private static let placeholder = "YOUR_OPENAI_API_KEY_HERE"

    static var openAIKey: String {
        get throws {
            try value(forKey: "OpenAIAPIKey",
                      placeholder: placeholder,
                      xcconfigName: "OPENAI_API_KEY")
        }
    }

    /// 키가 없거나 placeholder 그대로면 APIConfigError 를 throw 한다.
    static func value(forKey key: String,
                      placeholder: String,
                      xcconfigName: String) throws -> String {
        guard
            let value = Bundle.main.object(forInfoDictionaryKey: key) as? String,
            !value.isEmpty,
            value != placeholder
        else {
            throw APIConfigError.missingKey(key: key, xcconfigName: xcconfigName)
        }
        return value
    }
}
