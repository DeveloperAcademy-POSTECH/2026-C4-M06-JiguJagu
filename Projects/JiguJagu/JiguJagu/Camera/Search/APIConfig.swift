//
//  APIConfig.swift
//  JiguJagu
//
//  Created by SIA on 7/20/26.
//

import Foundation

enum APIConfig {

    /// 아직 키를 채우지 않았을 때의 플레이스홀더 값
    private static let placeholder = "YOUR_OPENAI_API_KEY_HERE"

    static var openAIKey: String {
        guard
            let key = Bundle.main.object(forInfoDictionaryKey: "OpenAIAPIKey") as? String,
            !key.isEmpty,
            key != placeholder
        else {
            assertionFailure("""
            OpenAI API 키가 설정되지 않았습니다.
            Secrets.xcconfig 의 OPENAI_API_KEY 값을 확인하고,
            Info.plist 에 OpenAIAPIKey = $(OPENAI_API_KEY) 가 있는지 확인하세요.
            """)
            return ""
        }
        return key
    }
}
