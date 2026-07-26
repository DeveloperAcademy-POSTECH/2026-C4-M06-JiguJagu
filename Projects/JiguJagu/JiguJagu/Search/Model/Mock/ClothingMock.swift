//
//  ClothingMock.swift
//  JiguJagu
//
//  Created by 채유성 on 7/19/26.
//

import Foundation

extension Clothing {
    static func randomReceiptData(for clothing: Clothing) -> Clothing {
        guard let mock = Clothing.mocks.randomElement() else {
            return clothing
        }
        
        return Clothing(
            brand: clothing.brand,
            productName: clothing.productName,
            mockImageName: clothing.mockImageName,
            productImageURL: clothing.productImageURL,
            receiptCategory: clothing.receiptCategory.isEmpty
            ? "\(clothing.category3) > \(clothing.category4)"
            : clothing.receiptCategory,
            category3: clothing.category3,
            category4: clothing.category4,
            howToCare: mock.howToCare,
            washingGuides: mock.washingGuides,
            materials: mock.materials,
            color: mock.color
        )
    }
    
    static let mocks: [Clothing] = [
        
        Clothing(
            brand: "CHICKS",
            productName: "더블 스트라이프 카라 니트",
            mockImageName: "P1",
            productImageURL: nil,
            receiptCategory: "상의 > 니트",
            category3: "상의",
            category4: "니트",
            howToCare: [
                "니트는 접어서 보관하세요.",
                "습기가 없는 곳에 보관하세요."
            ],
            washingGuides: [
                WashingGuide(id: "handwash", washingIcon: "HandwashOnly", washingDescription: "세탁 시 반드시 뒤집어서 30도씨의 중성세제를 사용하여 찬물로 단독 손 세탁을 하세요!"),
                WashingGuide(id: "bleach", washingIcon: "DoNotBleach", washingDescription: "염소 표백제나 강력 효소 세제는 제품에 손상을 줄 수 있으니 삼가주시길 바랍니다."),
                WashingGuide(id: "dry", washingIcon: "DryInShade", washingDescription: "건조기 사용 시 옷 형태나 컬러에 변형이 발생하니 자연 건조를 권장합니다.")
            ],
            materials: [
                Material(name: "Acrylic", percentage: 60),
                Material(name: "Polyester", percentage: 20),
                Material(name: "Wool", percentage: 15),
                Material(name: "Nylon", percentage: 5)
            ],
            color: "유색"
        ),
        
        Clothing(
            brand: "NIKE",
            productName: "윈드러너 후드 자켓",
            mockImageName: "P2",
            productImageURL: nil,
            receiptCategory: "아우터 > 재킷",
            category3: "아우터",
            category4: "재킷",
            howToCare: [
                "습기가 적은 곳에 보관하세요.",
                "세탁 후 충분히 건조해주세요."
            ],
            washingGuides: [
                WashingGuide(id: "iron", washingIcon: "Iron", washingDescription: "다림질 시에는 저온으로 맞춰서 진행해주시고, 의류 손상이 적게 천천히 다림질해주시길 바랍니다."),
                WashingGuide(id: "dry", washingIcon: "DryInShade", washingDescription: "건조기 사용 시 옷 형태나 컬러에 변형이 발생하니 자연 건조를 권장합니다.")
            ],
            materials: [
                Material(name: "Polyester", percentage: 100)
            ],
            color: "유색"
        ),
        
        Clothing(
            brand: "ZARA",
            productName: "오버핏 코튼 셔츠",
            mockImageName: "P3",
            productImageURL: nil,
            receiptCategory: "상의 > 셔츠",
            category3: "상의",
            category4: "셔츠",
            howToCare: [
                "형태 유지를 위해 옷걸이에 보관하세요.",
                "강한 햇빛은 피해 건조하세요."
            ],
            washingGuides: [
                WashingGuide(id: "wash", washingIcon: "HandwashOnly", washingDescription: "세탁 시 반드시 뒤집어서 30도씨의 중성세제를 사용하여 찬물로 단독 손 세탁을 하세요!"),
                WashingGuide(id: "bleach", washingIcon: "DoNotBleach", washingDescription: "염소 표백제나 강력 효소 세제는 제품에 손상을 줄 수 있으니 삼가주시길 바랍니다.")
            ],
            materials: [
                Material(name: "Polyester", percentage: 100)
            ],
            color: "흰색"
        ),
        
        Clothing(
            brand: "UNIQLO",
            productName: "울 블렌드 터틀넥 니트",
            mockImageName: "P4",
            productImageURL: nil,
            receiptCategory: "상의 > 니트",
            category3: "상의",
            category4: "니트",
            howToCare: [
                "늘어짐 방지를 위해 접어서 보관하세요."
            ],
            washingGuides: [
                WashingGuide(id: "handwash", washingIcon: "HandwashOnly", washingDescription: "세탁 시 반드시 뒤집어서 30도씨의 중성세제를 사용하여 찬물로 단독 손 세탁을 하세요!"),
                WashingGuide(id: "dry", washingIcon: "DryInShade", washingDescription: "건조기 사용 시 옷 형태나 컬러에 변형이 발생하니 자연 건조를 권장합니다.")
            ],
            materials: [
                Material(name: "Wool", percentage: 70),
                Material(name: "Nylon", percentage: 30)
            ],
            color: "유색"
        ),
        
        Clothing(
            brand: "H&M",
            productName: "브라운 스트라이프 긴팔 티셔츠",
            mockImageName: "P5",
            productImageURL: nil,
            receiptCategory: "상의 > 티셔츠",
            category3: "상의",
            category4: "티셔츠",
            howToCare: [
                "뒤집어서 세탁하면 색상을 오래 유지할 수 있습니다."
            ],
            washingGuides: [
                WashingGuide(id: "iron", washingIcon: "Iron", washingDescription: "다림질 시에는 저온으로 맞춰서 진행해주시고, 의류 손상이 적게 천천히 다림질해주시길 바랍니다.")
            ],
            materials: [
                Material(name: "Polyester", percentage: 95),
                Material(name: "Nylon", percentage: 5)
            ],
            color: "유색"
        ),
        
        Clothing(
            brand: "MANGO",
            productName: "배색 카라 가디건",
            mockImageName: "P6",
            productImageURL: nil,
            receiptCategory: "상의 > 가디건",
            category3: "상의",
            category4: "가디건",
            howToCare: [
                "옷걸이 사용 시 어깨 변형에 주의하세요."
            ],
            washingGuides: [
                WashingGuide(id: "handwash", washingIcon: "HandwashOnly", washingDescription: "세탁 시 반드시 뒤집어서 30도씨의 중성세제를 사용하여 찬물로 단독 손 세탁을 하세요!"),
                WashingGuide(id: "dry", washingIcon: "DryInShade", washingDescription: "건조기 사용 시 옷 형태나 컬러에 변형이 발생하니 자연 건조를 권장합니다.")
            ],
            materials: [
                Material(name: "Acrylic", percentage: 50),
                Material(name: "Polyester", percentage: 50)
            ],
            color: "유색"
        ),
        
        Clothing(
            brand: "ADIDAS",
            productName: "트랙 팬츠",
            mockImageName: "P1",
            productImageURL: nil,
            receiptCategory: "하의 > 팬츠",
            category3: "하의",
            category4: "팬츠",
            howToCare: [
                "마찰이 적은 환경에서 보관하세요."
            ],
            washingGuides: [
                WashingGuide(id: "wash", washingIcon: "HandwashOnly", washingDescription: "세탁 시 반드시 뒤집어서 30도씨의 중성세제를 사용하여 찬물로 단독 손 세탁을 하세요!"),
                WashingGuide(id: "dry", washingIcon: "DryInShade", washingDescription: "건조기 사용 시 옷 형태나 컬러에 변형이 발생하니 자연 건조를 권장합니다.")
            ],
            materials: [
                Material(name: "Polyester", percentage: 90),
                Material(name: "Nylon", percentage: 10)
            ],
            color: "검정색"
        ),
        
        Clothing(
            brand: "LEVIS",
            productName: "501 데님 청바지",
            mockImageName: "P2",
            productImageURL: nil,
            receiptCategory: "하의 > 데님",
            category3: "하의",
            category4: "데님",
            howToCare: [
                "잦은 세탁은 데님 색상 변화를 유발할 수 있습니다."
            ],
            washingGuides: [
                WashingGuide(id: "dry", washingIcon: "DryInShade", washingDescription: "건조기 사용 시 옷 형태나 컬러에 변형이 발생하니 자연 건조를 권장합니다.")
            ],
            materials: [
                Material(name: "Nylon", percentage: 100)
            ],
            color: "유색"
        ),
        
        Clothing(
            brand: "THE NORTH FACE",
            productName: "눕시 패딩 자켓",
            mockImageName: "P3",
            productImageURL: nil,
            receiptCategory: "아우터 > 패딩",
            category3: "아우터",
            category4: "패딩",
            howToCare: [
                "압축 보관을 피하고 형태를 유지해주세요."
            ],
            washingGuides: [
                WashingGuide(id: "dry", washingIcon: "DryInShade", washingDescription: "건조기 사용 시 옷 형태나 컬러에 변형이 발생하니 자연 건조를 권장합니다.")
            ],
            materials: [
                Material(name: "Nylon", percentage: 100)
            ],
            color: "검정색"
        ),
        
        Clothing(
            brand: "PATAGONIA",
            productName: "플리스 집업 자켓",
            mockImageName: "P4",
            productImageURL: nil,
            receiptCategory: "아우터 > 플리스",
            category3: "아우터",
            category4: "플리스",
            howToCare: [
                "섬유 손상을 방지하기 위해 약하게 세탁하세요."
            ],
            washingGuides: [
                WashingGuide(id: "wash", washingIcon: "HandwashOnly", washingDescription: "세탁 시 반드시 뒤집어서 30도씨의 중성세제를 사용하여 찬물로 단독 손 세탁을 하세요!"),
                WashingGuide(id: "dry", washingIcon: "DryInShade", washingDescription: "건조기 사용 시 옷 형태나 컬러에 변형이 발생하니 자연 건조를 권장합니다.")
            ],
            materials: [
                Material(name: "Polyester", percentage: 100)
            ],
            color: "흰색"
        )
    ]
}
