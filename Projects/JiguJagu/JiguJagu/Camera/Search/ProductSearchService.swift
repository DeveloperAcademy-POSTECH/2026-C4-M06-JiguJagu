//
//  ProductSearchService.swift
//  JiguJagu
//
//  Created by SIA on 7/20/26.
//

import UIKit

// MARK: - 카테고리 체계 (Figma 디자인과 동일)

/// 대분류 → 세부분류 매핑. 프롬프트와 검증에 함께 사용합니다.
enum ClothingCategory {
    static let taxonomy: [String: [String]] = [
        "TOP":    ["티셔츠", "피케/카라티", "후드", "맨투맨/블라우스", "기타 상의"],
        "BOTTOM": ["청바지", "트레이닝팬츠", "숏팬츠", "스커트/원피스", "기타 하의"],
        "OUTER":  ["집업", "재킷", "코트", "패딩", "기타 아우터"],
        "ETC":    ["기타"]
    ]

    /// 대분류 코드 → 한국어 표시명
    static let displayName: [String: String] = [
        "TOP": "상의", "BOTTOM": "하의", "OUTER": "아우터", "ETC": "기타"
    ]
}

// MARK: - 결과 모델

/// OpenAI가 사진을 분석해 돌려주는 의류 식별 결과.
struct ClothingIdentification: Codable {
    let itemName: String            // 품목/상품명 (예: "오버핏 후드 집업")
    let category: String            // TOP / BOTTOM / OUTER / ETC
    let subCategory: String         // 티셔츠 / 청바지 / 집업 등 (세부 종류)
    let brand: String?              // 추정 브랜드 (없으면 nil)
    let colors: [String]            // 주요 색상
    let material: String?           // 추정 소재
    let pattern: String?            // 패턴 (무지/스트라이프/체크/그래픽 등)
    let searchKeywords: [String]    // 쇼핑 검색용 키워드
    let itemDescription: String     // 한 줄 설명
    let confidence: Double?         // 0.0 ~ 1.0 신뢰도

    enum CodingKeys: String, CodingKey {
        case itemName, category, subCategory, brand, colors
        case material, pattern, searchKeywords, confidence
        case itemDescription = "description"
    }

    /// 대분류 한국어 표시명 (예: "상의")
    var categoryDisplayName: String {
        ClothingCategory.displayName[category] ?? category
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
        // 1) 이미지 축소 + JPEG 압축 + base64 (정확도를 위해 품질 0.8)
        guard let base64 = image
            .resized(maxDimension: 1024)
            .jpegData(compressionQuality: 0.8)?
            .base64EncodedString()
        else {
            throw ProductSearchError.imageEncodingFailed
        }

        // 2) 요청 본문 구성
        let requestBody: [String: Any] = [
            "model": model,
            "response_format": ["type": "json_object"],
            "messages": [
                ["role": "system", "content": Self.systemPrompt],
                ["role": "user", "content": [
                    ["type": "text", "text": "이 옷을 분석해서 지정된 JSON 형식으로만 답하세요."],
                    ["type": "image_url",
                     "image_url": [
                        "url": "data:image/jpeg;base64,\(base64)",
                        "detail": "high"   // 고해상도 분석으로 정확도 향상
                     ]]
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

    // MARK: - 프롬프트

    /// 정확도를 높이기 위한 상세 분석 지침 + Figma 카테고리 체계.
    private static let systemPrompt = """
    당신은 의류 상품 식별 전문가입니다. 업로드된 사진 속 옷 한 벌을 정밀하게 분석합니다.

    [분석 순서 — 반드시 이 순서로 꼼꼼히 관찰]
    1. 전체 실루엣으로 상의/하의/아우터 구분
    2. 넥라인·칼라 형태 (라운드넥, 카라, 후드 등)
    3. 소매 길이와 형태 (긴팔/반팔/민소매)
    4. 여밈 방식 (지퍼, 단추, 없음) — 아우터 판별의 핵심
    5. 기장과 핏 (오버핏, 슬림 등)
    6. 소재·질감 (면, 니트, 데님, 패딩, 트레이닝 원단 등)
    7. 색상과 패턴 (무지/스트라이프/체크/그래픽)
    8. 로고·그래픽·택 등 브랜드 단서

    [카테고리 분류 — category와 subCategory는 아래 목록에서 정확히 하나씩만 선택]
    - TOP(상의): 티셔츠, 피케/카라티, 후드, 맨투맨/블라우스, 기타 상의
    - BOTTOM(하의): 청바지, 트레이닝팬츠, 숏팬츠, 스커트/원피스, 기타 하의
    - OUTER(아우터): 집업, 재킷, 코트, 패딩, 기타 아우터
    - ETC(기타): 기타

    규칙:
    - subCategory는 반드시 선택한 category에 속한 목록 안에서만 고른다.
    - 지퍼나 단추로 앞이 완전히 열리는 겉옷이면 TOP이 아니라 OUTER로 분류한다.
      (예: 후드 형태라도 지퍼로 열리면 OUTER의 "집업")
    - 애매하면 그 대분류의 "기타 ○○"를 선택한다.

    [출력 — 코드블록·설명 없이 아래 JSON만 출력]
    {
      "itemName": "구체적인 한국어 품목명",
      "category": "TOP | BOTTOM | OUTER | ETC 중 하나",
      "subCategory": "위 목록 중 정확히 하나",
      "brand": "확실한 근거가 있을 때만 브랜드명, 없으면 null",
      "colors": ["주요 색상 1~3개"],
      "material": "추정 소재 또는 null",
      "pattern": "무지 | 스트라이프 | 체크 | 그래픽 | 기타",
      "searchKeywords": ["실제 쇼핑몰 검색에 통하는 자연스러운 한국어 키워드 3~5개"],
      "description": "옷을 설명하는 한 문장",
      "confidence": 0.0에서 1.0 사이 숫자
    }

    [중요]
    - brand는 로고·택 등 확실한 근거가 있을 때만 채우고, 불확실하면 반드시 null.
    - 확신이 낮은 항목이 있으면 confidence를 낮게 매긴다.
    """
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
