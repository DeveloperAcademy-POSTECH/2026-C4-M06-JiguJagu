//
//  NaverShoppingService.swift
//  JiguJagu
//
//  Created by SIA on 7/21/26.
//
//  네이버 검색 API (쇼핑) 연동 계층
//  Docs: https://developers.naver.com/docs/serviceapi/search/shopping/shopping.md
//

import Foundation


// MARK: - Error

enum NaverShoppingError: LocalizedError {
    case invalidURL
    case invalidResponse
    case requestFailed(statusCode: Int)
    case decodingFailed(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "요청 URL 생성에 실패했습니다."
        case .invalidResponse:
            return "서버 응답 형식이 올바르지 않습니다."
        case .requestFailed(let code):
            return "요청 실패 (HTTP \(code)). Client ID/Secret 또는 API 권한을 확인하세요."
        case .decodingFailed(let error):
            return "디코딩 실패: \(error.localizedDescription)"
        }
    }
}

// MARK: - Sort Option

enum NaverShoppingSort: String {
    case similarity = "sim"  // 정확도순 (기본, 유사 상품 검색에 적합)
    case date       = "date" // 날짜순
    case priceAsc   = "asc"  // 가격 오름차순
    case priceDesc  = "dsc"  // 가격 내림차순
}

// MARK: - Service

final class NaverShoppingService {

    private let clientID: String
    private let clientSecret: String
    private let session: URLSession
    private let baseURL = "https://openapi.naver.com/v1/search/shop.json"

    /// ⚠️ 보안: 클라이언트(iOS) 앱에 Secret 을 직접 넣으면 바이너리에서 추출될 수 있음.
    ///    실서비스에서는 자체 백엔드를 두고 프록시하는 것을 권장.
    init(clientID: String,
         clientSecret: String,
         session: URLSession = .shared) {
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.session = session
    }

    /// 쇼핑 검색
    /// - Parameters:
    ///   - query: 검색어 (한글 OK, URLComponents 가 자동 인코딩)
    ///   - display: 1~100 (기본 10)
    ///   - start: 1~1000 (기본 1)
    ///   - sort: 정렬 기준 (기본 정확도순)
    func search(query: String,
                display: Int = 10,
                start: Int = 1,
                sort: NaverShoppingSort = .similarity) async throws -> [NaverShoppingItem] {

        guard var components = URLComponents(string: baseURL) else {
            throw NaverShoppingError.invalidURL
        }
        components.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "display", value: String(min(max(display, 1), 100))),
            URLQueryItem(name: "start", value: String(min(max(start, 1), 1000))),
            URLQueryItem(name: "sort", value: sort.rawValue)
        ]
        guard let url = components.url else {
            throw NaverShoppingError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(clientID, forHTTPHeaderField: "X-Naver-Client-Id")
        request.setValue(clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")

        let (data, response) = try await session.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw NaverShoppingError.invalidResponse
        }
        guard (200..<300).contains(http.statusCode) else {
            throw NaverShoppingError.requestFailed(statusCode: http.statusCode)
        }

        do {
            let decoded = try JSONDecoder().decode(NaverShoppingResponseDTO.self, from: data)
            return decoded.items
        } catch {
            throw NaverShoppingError.decodingFailed(error)
        }
    }
}
