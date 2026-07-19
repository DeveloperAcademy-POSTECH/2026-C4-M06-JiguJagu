//
//  ProductSearchService.swift
//  JiguJagu
//
//  Created by SIA on 7/20/26.
//

import UIKit

// MARK: - 결과 모델

/// OpenAI가 사진을 분석해 돌려주는 의류 식별 결과.
struct ClothingIdentification: Codable {
    let itemName: String          // 품목/상품명 (예: "오버핏 후드 집업")
    let category: String          // TOP / OUTER / BOTTOM / ETC
    let brand: String?            // 추정 브랜드 (없으면 nil)
    let colors: [String]          // 주요 색상
    let searchKeywords: [String]  // 쇼핑 검색용 키워드
    let itemDescription: String   // 한 줄 설명

    enum CodingKeys: String, CodingKey {
        case itemName, category, brand, colors, searchKeywords
        case itemDescription = "description"
    }
}

// MARK: - 에러

enum ProductSearchError: LocalizedError {
    case imageEncodingFailed
    case invalidResponse
    case apiError(Int, String)
    case emptyContent
    case decodingFailed

    var errorDescription: String? {
        switch self {
        case .imageEncodingFailed: return "이미지를 변환하지 못했습니다."
        case .invalidResponse:     return "서버 응답이 올바르지 않습니다."
        case .apiError(let code, let msg): return "API 오류 (\(code)): \(msg)"
        case .emptyContent:        return "분석 결과가 비어 있습니다."
        case .decodingFailed:      return "결과를 해석하지 못했습니다."
        }
    }
}

// MARK: - 서비스

struct ProductSearchService {

    /// 사용할 비전 모델. 비용을 줄이려면 더 가벼운 모델로 교체 가능.
    private let model = "gpt-5.6"
    private let endpoint = URL(string: "https://api.openai.com/v1/chat/completions")!
    private let apiKey: String

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    /// 옷 사진을 분석해 상품 정보를 반환합니다.
    func identify(image: UIImage) async throws -> ClothingIdentification {
        // 1) 이미지 축소 + JPEG 압축 + base64 (토큰/비용 절약)
        guard let base64 = image
            .resized(maxDimension: 1024)
            .jpegData(compressionQuality: 0.7)?
            .base64EncodedString()
        else {
            throw ProductSearchError.imageEncodingFailed
        }

        // 2) 요청 본문 구성
        let systemPrompt = """
        당신은 의류 상품 식별 전문가입니다. 사진 속 옷 한 벌을 분석하여 \
        아래 형식의 JSON으로만 응답하세요. 코드블록이나 설명 없이 순수 JSON만 출력합니다.
        {
          "itemName": "한국어 품목명",
          "category": "TOP | OUTER | BOTTOM | ETC 중 하나",
          "brand": "추정 브랜드 또는 null",
          "colors": ["주요 색상"],
          "searchKeywords": ["쇼핑 검색에 쓸 키워드 3~5개"],
          "description": "옷을 설명하는 한 문장"
        }
        확신이 없으면 추측하되 가장 그럴듯한 값을 넣으세요.
        """

        let requestBody: [String: Any] = [
            "model": model,
            "response_format": ["type": "json_object"],
            "messages": [
                ["role": "system", "content": systemPrompt],
                ["role": "user", "content": [
                    ["type": "text", "text": "이 옷의 상품 정보를 JSON으로 알려줘."],
                    ["type": "image_url",
                     "image_url": ["url": "data:image/jpeg;base64,\(base64)"]]
                ]]
            ]
        ]

        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)

        // 3) 호출
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw ProductSearchError.invalidResponse
        }
        guard (200..<300).contains(http.statusCode) else {
            let msg = String(data: data, encoding: .utf8) ?? "알 수 없는 오류"
            throw ProductSearchError.apiError(http.statusCode, msg)
        }

        // 4) 응답에서 content(JSON 문자열) 추출 후 다시 디코딩
        let completion = try JSONDecoder().decode(ChatCompletionResponse.self, from: data)
        guard let content = completion.choices.first?.message.content,
              let contentData = content.data(using: .utf8) else {
            throw ProductSearchError.emptyContent
        }

        do {
            return try JSONDecoder().decode(ClothingIdentification.self, from: contentData)
        } catch {
            throw ProductSearchError.decodingFailed
        }
    }
}

// MARK: - OpenAI 응답 파싱용

private struct ChatCompletionResponse: Codable {
    let choices: [Choice]
    struct Choice: Codable { let message: Message }
    struct Message: Codable { let content: String }
}

// MARK: - 이미지 축소 유틸

extension UIImage {
    /// 가장 긴 변을 maxDimension 이하로 줄인 이미지를 반환합니다.
    func resized(maxDimension: CGFloat) -> UIImage {
        let longestSide = max(size.width, size.height)
        guard longestSide > maxDimension else { return self }

        let scale = maxDimension / longestSide
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
