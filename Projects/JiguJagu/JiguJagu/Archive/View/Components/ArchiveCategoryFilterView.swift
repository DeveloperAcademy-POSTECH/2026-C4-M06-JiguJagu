//
//  ArchiveCategoryFilterView.swift
//  JiguJagu
//
//  Created by Codex on 7/20/26.
//

import SwiftUI

struct ArchiveCategoryFilterView: View {
    let categories: [ArchiveCategory]
    let selectedCategory: ArchiveCategory
    let subcategories: [ArchiveSubcategory]
    let selectedSubcategory: ArchiveSubcategory?
    let onCategoryTap: (ArchiveCategory) -> Void
    let onSubcategoryTap: (ArchiveSubcategory) -> Void

    var body: some View {
        VStack(spacing: 0) {
            categoryTabs

            Divider()
                .background(Color.grayScale200)

            subcategoryChips
        }
    }
}

private extension ArchiveCategoryFilterView {
    var categoryTabs: some View {
        HStack(spacing: 0) {
            ForEach(categories) { category in
                Button {
                    onCategoryTap(category)
                } label: {
                    Text(category.title)
                        .font(.pretendard.head1)
                        .foregroundStyle(categoryTextColor(category))
                        .frame(maxWidth: .infinity)
                        .frame(height: 66)
                        .overlay(alignment: .bottom) {
                            if selectedCategory == category {
                                Rectangle()
                                    .fill(Color.grayScale900)
                                    .frame(height: 2)
                            }
                        }
                }
            }
        }
        .background(Color.white)
    }

    var subcategoryChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 14) {
                ForEach(subcategories) { subcategory in
                    Button {
                        onSubcategoryTap(subcategory)
                    } label: {
                        Text(subcategory.title)
                            .font(.pretendard.head3)
                            .foregroundStyle(chipTextColor(subcategory))
                            .padding(.horizontal, 22)
                            .frame(height: 68)
                            .background(chipBackgroundColor(subcategory))
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal, 32)
        }
        .frame(height: 128)
        .background(Color.white)
    }

    func categoryTextColor(_ category: ArchiveCategory) -> Color {
        selectedCategory == category ? .grayScale900 : .grayScale500
    }

    func chipTextColor(_ subcategory: ArchiveSubcategory) -> Color {
        selectedSubcategory == subcategory ? .white : .grayScale600
    }

    func chipBackgroundColor(_ subcategory: ArchiveSubcategory) -> Color {
        selectedSubcategory == subcategory ? .primary500 : .grayScale100
    }
}
