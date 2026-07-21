//
//  ArchiveCategoryFilterView.swift
//  JiguJagu
//
//

import SwiftUI

struct ArchiveCategoryFilterView: View {
    let categories: [ArchiveCategory]
    let selectedCategory: ArchiveCategory
    let subcategories: [ArchiveSubcategory]
    let selectedSubcategory: ArchiveSubcategory?
    let onCategoryTap: (ArchiveCategory) -> Void
    let onAllSubcategoryTap: () -> Void
    let onSubcategoryTap: (ArchiveSubcategory) -> Void

    var body: some View {
        VStack(spacing: 0) {
            categoryTabs

            Divider()
                .background(Color.grayScale200)

            subcategoryChips
        }
        .frame(height: 108)
        .background(Color.white)
        .zIndex(1)
    }
}

private extension ArchiveCategoryFilterView {
    var selectedSubcategoryID: String {
        selectedSubcategory?.id ?? "all"
    }

    var categoryTabs: some View {
        HStack(spacing: 0) {
            ForEach(categories) { category in
                Button {
                    onCategoryTap(category)
                } label: {
                    Text(category.title)
                        .font(.pretendard.head4)
                        .tracking(0.32)
                        .foregroundStyle(categoryTextColor(category))
                        .frame(maxWidth: .infinity)
                        .frame(height: 37)
                        .overlay(alignment: .bottom) {
                            if selectedCategory == category {
                                Rectangle()
                                    .fill(Color.grayScale900)
                                    .frame(height: 2)
                            }
                        }
                }
                .buttonStyle(.plain)
                .contentShape(Rectangle())
            }
        }
        .background(Color.white)
    }

    var subcategoryChips: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                LazyHStack(spacing: 14) {
                    subcategoryChip(
                        id: "all",
                        title: "전체",
                        isSelected: selectedSubcategory == nil,
                        action: onAllSubcategoryTap
                    )

                    ForEach(subcategories) { subcategory in
                        subcategoryChip(
                            id: subcategory.id,
                            title: subcategory.title,
                            isSelected: selectedSubcategory == subcategory,
                            action: {
                                onSubcategoryTap(subcategory)
                            }
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 6)
                .frame(height: 70, alignment: .center)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            }
            .scrollIndicators(.hidden)
            .scrollBounceBehavior(.always)
            .frame(height: 70)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
            .onChange(of: selectedSubcategoryID) { _, id in
                withAnimation(.easeInOut(duration: 0.2)) {
                    proxy.scrollTo(id, anchor: .center)
                }
            }
        }
    }

    func categoryTextColor(_ category: ArchiveCategory) -> Color {
        selectedCategory == category ? .grayScale900 : .grayScale500
    }

    func subcategoryChip(
        id: String,
        title: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        chipTitle(title, isSelected: isSelected)
        .id(id)
        .frame(minHeight: 56)
        .background(Color.white.opacity(0.001))
        .contentShape(Rectangle())
        .highPriorityGesture(
            TapGesture().onEnded(action)
        )
        .accessibilityAddTraits(.isButton)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    func chipTitle(_ title: String, isSelected: Bool) -> some View {
        Text(title)
            .font(.pretendard.body3)
            .foregroundStyle(isSelected ? Color.white : Color.grayScale500)
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: false)
            .padding(.horizontal, 14)
            .frame(height: 38)
            .background(isSelected ? Color.primary500 : Color.grayScale100)
            .clipShape(Capsule())
    }
}

#Preview("Selected Subcategory") {
    ArchiveCategoryFilterView(
        categories: ArchiveCategory.allCases,
        selectedCategory: .all,
        subcategories: ArchiveSubcategory.all,
        selectedSubcategory: ArchiveSubcategory.tops[0],
        onCategoryTap: { _ in },
        onAllSubcategoryTap: {},
        onSubcategoryTap: { _ in }
    )
}
