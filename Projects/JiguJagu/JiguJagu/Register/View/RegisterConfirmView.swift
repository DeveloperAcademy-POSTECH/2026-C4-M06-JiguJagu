//
//  RegisterConfirmView.swift
//  JiguJagu
//
//  Created by 채유성 on 7/21/26.
//

import SwiftUI

struct RegisterConfirmView: View {
    let image: UIImage?
    let brand: String
    let productName: String
    var onBack: () -> Void = {}
    @State private var selectedMainCategory = "상의"
    @State private var selectedSubCategory = "니트"
    @State private var selectedColor: RegisterColorOption? = .colored
    
    var body: some View {
        ScrollView {
            RegisterHeaderView(onBack: onBack)
            VStack(alignment: .leading, spacing: 24) {
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("옷 정보를 확인해주세요!")
                        .font(.title2).fontWeight(.bold)
                    Text("정보 확인 후, 의류 영수증을 발급해보세요.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom, 8)
                
                HStack {
                    Spacer()
                    ClothingImageCard(image: image)
                    Spacer()
                }
                
                RegisterInfoField(
                    title: "브랜드명",
                    value: brand,
                    titleFont: Font.pretendard.head4,
                    valueFont: Font.pretendard.head4,
                    titleColor: Color.grayScale900,
                    valueColor: Color.grayScale500
                )
                
                RegisterInfoField(
                    title: "제품명",
                    value: productName,
                    titleFont: Font.pretendard.head4,
                    valueFont: Font.pretendard.head4,
                    titleColor: Color.grayScale900,
                    valueColor: Color.grayScale500
                )
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("카테고리")
                        .font(Font.pretendard.head4)
                    RegisterChipFlowLayout {
                        RegisterSelectionChip(title: "상의", isSelected: selectedMainCategory == "상의") {
                            selectedMainCategory = "상의"
                        }
                        RegisterSelectionChip(title: "하의", isSelected: selectedMainCategory == "하의") {
                            selectedMainCategory = "하의"
                        }
                        RegisterSelectionChip(title: "아우터", isSelected: selectedMainCategory == "아우터") {
                            selectedMainCategory = "아우터"
                        }
                        RegisterSelectionChip(title: "그 외", isSelected: selectedMainCategory == "그 외") {
                            selectedMainCategory = "그 외"
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("세부 카테고리")
                        .font(Font.pretendard.head4)
                    RegisterChipFlowLayout {
                        RegisterSelectionChip(title: "티셔츠", isSelected: selectedSubCategory == "티셔츠") {
                            selectedSubCategory = "티셔츠"
                        }
                        RegisterSelectionChip(title: "니트", isSelected: selectedSubCategory == "니트") {
                            selectedSubCategory = "니트"
                        }
                        RegisterSelectionChip(title: "후드", isSelected: selectedSubCategory == "후드") {
                            selectedSubCategory = "후드"
                        }
                        RegisterSelectionChip(title: "피케/카라티", isSelected: selectedSubCategory == "피케/카라티") {
                            selectedSubCategory = "피케/카라티"
                        }
                        RegisterSelectionChip(title: "맨투맨", isSelected: selectedSubCategory == "맨투맨") {
                            selectedSubCategory = "맨투맨"
                        }
                        RegisterSelectionChip(title: "셔츠/블라우스", isSelected: selectedSubCategory == "셔츠/블라우스") {
                            selectedSubCategory = "셔츠/블라우스"
                        }
                        RegisterSelectionChip(title: "그 외", isSelected: selectedSubCategory == "그 외") {
                            selectedSubCategory = "그 외"
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("색상")
                        .font(Font.pretendard.head4)
                    RegisterChipFlowLayout {
                        RegisterColorChip(option: .black, isSelected: selectedColor == .black) {
                            selectedColor = .black
                        }
                        RegisterColorChip(option: .white, isSelected: selectedColor == .white) {
                            selectedColor = .white
                        }
                        RegisterColorChip(option: .colored, isSelected: selectedColor == .colored) {
                            selectedColor = .colored
                        }
                    }
                }
                
                Spacer(minLength: 24)
                
                HStack(alignment: .center, spacing: 8) {
                    Button(action: {}) {
                        Text("재등록")
                            .font(Font.pretendard.head3)
                            .foregroundStyle(Color.grayScale900)
                            .frame(width: 118, height: 52, alignment: .center)
                            .background(Color.grayScale200)
                            .cornerRadius(83)
                    }
                    .buttonStyle(.plain)
                    
                    Button(action: {}) {
                        Text("의류영수증 발급")
                            .font(Font.pretendard.head3)
                            .foregroundStyle(Color.white)
                            .frame(width: 236, height: 52, alignment: .center)
                            .background(Color.primary500)
                            .cornerRadius(83)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.top, 8)
            }
            .padding()
        }
    }
}

private struct RegisterInfoField: View {
    let title: String
    let value: String
    let titleFont: Font
    let valueFont: Font
    var titleColor: Color = Color.grayScale900
    var valueColor: Color = Color.grayScale500
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(titleFont)
                .foregroundStyle(titleColor)
            
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.grayScale100)
                .frame(height: 48)
                .overlay {
                    HStack {
                        Text(value)
                            .font(valueFont)
                            .foregroundStyle(valueColor)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                }
        }
    }
}

private struct ClothingImageCard: View {
    let image: UIImage?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.grayScale50)
                .overlay {
                    RoundedRectangle(cornerRadius: 4)
                        .strokeBorder(Color.grayScale200, lineWidth: 1)
                }
                .frame(width: 180, height: 182)
            
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 122, height: 121)
            } else {
                Text("이미지를 로드할 수 없습니다")
                    .font(.pretendard.body5)
                    .foregroundStyle(Color.grayScale400)
                    .multilineTextAlignment(.center)
                    .frame(width: 122, height: 121)
            }
        }
        .frame(width: 180, height: 182)
    }
}

#Preview("이미지 있음") {
    RegisterConfirmView(
        image: UIImage(systemName: "P1"),
        brand: "CHICKS",
        productName: "더블 스트라이프 카라 니트"
    )
}

#Preview("이미지 없음") {
    RegisterConfirmView(
        image: nil,
        brand: "CHICKS",
        productName: "더블 스트라이프 카라 니트"
    )
}
