//
//  RegisterConfirmView.swift
//  JiguJagu
//
//  Created by 채유성 on 7/21/26.
//

import SwiftUI

struct RegisterConfirmView: View {
    
    let clothing: Clothing
    
    private var categoryText: String {
        clothing.receiptCategory
    }
    var localImage: UIImage? = nil
    
    var onBack: () -> Void = {}
    @Environment(\.dismiss) private var dismiss
    @State private var selectedMainCategory = ""
    @State private var selectedSubCategory: ArchiveSubcategory?
    @State private var selectedColor: RegisterColorOption?
    @State private var editableBrand: String = ""
    @State private var editableProductName: String = ""
    @State private var showReceipt = false

    /// 이미지 카드에서 재촬영한 사진(누끼 처리됨). 있으면 최우선 사용.
    @State private var retakenImage: UIImage?
    @State private var showCamera = false

    /// 카드/영수증에 표시할 이미지. 재촬영 > 전달받은 사진 순.
    private var displayImage: UIImage? {
        // 재촬영 > 전달받은 사진 > 최근 촬영(전역 저장소) 순
        retakenImage ?? localImage ?? CapturedImageStore.shared.lastCutoutImage
    }
    
    private func convertMainCategory(
        _ category: String
    ) -> String {
        switch category {
        case let value where value.contains("상의") || value.contains("티셔츠") || value.contains("니트") || value.contains("셔츠"):
            return "상의"
        case let value where value.contains("하의") || value.contains("팬츠") || value.contains("바지"):
            return "하의"
        case let value where value.contains("아우터") || value.contains("재킷") || value.contains("코트") || value.contains("패딩"):
            return "아우터"
        default:
            return "그 외"
        }
    }
    
    private var availableSubcategories: [ArchiveSubcategory] {
        switch selectedMainCategory {
        case "상의":
            return ArchiveSubcategory.tops
        case "하의":
            return ArchiveSubcategory.bottoms
        case "아우터":
            return ArchiveSubcategory.outers
        default:
            return []
        }
    }
    
    private var updatedClothing: Clothing {
        Clothing(
            brand: editableBrand,
            productName: editableProductName,
            mockImageName: clothing.mockImageName,
            productImageURL: clothing.productImageURL,
            receiptCategory: clothing.receiptCategory,
            category3: clothing.category3,
            category4: clothing.category4,
            howToCare: clothing.howToCare,
            washingGuides: clothing.washingGuides,
            materials: clothing.materials,
            color: clothing.color
        )
    }
    
    init(
        clothing: Clothing,
        localImage: UIImage? = nil,
        onBack: @escaping () -> Void = {}
    ) {
        self.clothing = clothing
        self.localImage = localImage
        self.onBack = onBack
        
        _editableBrand = State(
            initialValue: clothing.brand
        )
        
        _editableProductName = State(
            initialValue: clothing.productName
        )
        
        _selectedMainCategory = State(
            initialValue: clothing.category3
        )
        
        _selectedSubCategory = State(
            initialValue: ArchiveSubcategory.all.first {
                $0.title == clothing.category4
            }
        )
        _selectedColor = State(
            initialValue: RegisterColorOption.allCases.first {
                $0.title == clothing.color
            }
        )
    }
    
    var body: some View {
        ScrollView {
            RegisterHeaderView(
                onBack: {
                    onBack()
                    dismiss()
                }
            )
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
                    ClothingImageCard(
                        localImage: displayImage,
                        url: clothing.productImageURL,
                        onCameraTap: { showCamera = true }
                    )
                    Spacer()
                }
                
                RegisterInfoField(
                    title: "브랜드명",
                    value: $editableBrand,
                    titleFont: Font.pretendard.head4,
                    valueFont: Font.pretendard.head4,
                    titleColor: Color.grayScale900,
                    valueColor: Color.grayScale500
                )
                
                RegisterInfoField(
                    title: "제품명",
                    value: $editableProductName,
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
                            selectedSubCategory = nil
                        }
                        RegisterSelectionChip(title: "하의", isSelected: selectedMainCategory == "하의") {
                            selectedMainCategory = "하의"
                            selectedSubCategory = nil
                        }
                        RegisterSelectionChip(title: "아우터", isSelected: selectedMainCategory == "아우터") {
                            selectedMainCategory = "아우터"
                            selectedSubCategory = nil
                        }
                        RegisterSelectionChip(title: "그 외", isSelected: selectedMainCategory == "그 외") {
                            selectedMainCategory = "그 외"
                            selectedSubCategory = nil
                        }
                    }
                }
                
                if selectedMainCategory != "그 외" {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("세부 카테고리")
                            .font(Font.pretendard.head4)
                        
                        RegisterChipFlowLayout {
                            ForEach(availableSubcategories) { category in
                                RegisterSelectionChip(
                                    title: category.title,
                                    isSelected: selectedSubCategory?.id == category.id
                                ) {
                                    selectedSubCategory = category
                                }
                            }
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
                    
                    
                    Button {
                        
                        showReceipt = true
                        
                    } label: {
                        Text("영수증 발급")
                            .font(Font.pretendard.head3)
                            .foregroundStyle(Color.white)
                            .frame(width: 371, height: 52, alignment: .center)
                            .background(Color.primary500)
                            .cornerRadius(83)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.top, 8)
            }
            .padding()
        }
        .navigationDestination(isPresented: $showReceipt) {
            
            ReceiptLoadingFlowView(
                
                clothing: Clothing.randomReceiptData(for: updatedClothing),
                localImage: displayImage
                
            )
            
        }
        .fullScreenCover(isPresented: $showCamera) {
            RetakeCameraView { captured in
                showCamera = false
                Task {
                    // 재촬영 사진도 누끼 처리 후 사용
                    let normalized = captured.normalizedUp()
                    let cutout = await ForegroundCutout.extract(from: normalized)
                    retakenImage = cutout ?? captured
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

/// 재촬영 전용 카메라 화면. 옷 촬영 설정으로 한 장 찍고 콜백으로 넘긴다.
private struct RetakeCameraView: View {
    @Environment(\.dismiss) private var dismiss
    let onCapture: (UIImage) -> Void

    var body: some View {
        CameraCaptureView(
            config: .clothing,
            onLeadingAction: { dismiss() },
            onCapture: { image in
                onCapture(image)
            }
        )
    }
}

private struct RegisterInfoField: View {
    let title: String
    @Binding var value: String
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
                        TextField("", text: $value)
                            .font(valueFont)
                            .foregroundStyle(valueColor)
                            .textFieldStyle(.plain)
                        
                        if !value.isEmpty {
                            Button {
                                value = ""
                            } label: {
                                Image(systemName: "xmark")
                                    .foregroundStyle(Color.grayScale400)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                }
        }
    }
}

private struct ClothingImageCard: View {
    var localImage: UIImage? = nil
    let url: URL?
    var onCameraTap: () -> Void = {}
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.grayScale50)
                .overlay {
                    RoundedRectangle(cornerRadius: 4)
                        .strokeBorder(Color.grayScale200, lineWidth: 1)
                }
                .frame(width: 180, height: 182)
            
            if let localImage {
                // 재촬영/전달받은 로컬 이미지 우선 표시 (박스 크기에 꽉 차게)
                Image(uiImage: localImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 172, height: 174)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
            } else if let url {
                
                AsyncImage(url: url) { phase in
                    
                    switch phase {
                        
                    case .success(let image):
                        
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(
                                width: 122,
                                height: 121
                            )
                        
                    default:
                        
                        Text("이미지를 로드할 수 없습니다")
                            .font(.pretendard.body5)
                            .foregroundStyle(Color.grayScale400)
                        
                    }
                }
                
                .frame(width: 180, height: 182)
            }

            // 우측 상단 카메라 버튼 (재촬영)
            VStack {
                HStack {
                    Spacer()
                    Button(action: onCameraTap) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color.grayScale600)
                            .frame(width: 36, height: 36)
                            .background(Color.grayScale200)
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                }
                Spacer()
            }
            .frame(width: 180, height: 182)
            .padding(8)
        }
    }
}

#Preview {
    RegisterConfirmView(
        clothing: Clothing(
            from: NaverShoppingItem(
                title: "더블 스트라이프 카라 니트",
                image: "https://shopping-phinf.pstatic.net/sample.jpg",
                brand: "CHICKS",
                maker: "CHICKS",
                category3: "상의",
                category4: "니트"
            )
        )
    )
}
