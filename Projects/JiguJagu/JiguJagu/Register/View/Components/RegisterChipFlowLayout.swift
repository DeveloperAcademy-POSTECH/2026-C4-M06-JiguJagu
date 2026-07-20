//
//  RegisterChipFlowLayout.swift
//  JiguJagu
//
//  Created by Codex on 7/21/26.
//

import SwiftUI

struct RegisterChipFlowLayout: Layout {
    let horizontalSpacing: CGFloat
    let verticalSpacing: CGFloat

    init(
        horizontalSpacing: CGFloat = 8,
        verticalSpacing: CGFloat = 16
    ) {
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
    }

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        let rows = makeRows(
            proposal: proposal,
            subviews: subviews
        )

        return CGSize(
            width: proposal.width ?? rows.map(\.width).max() ?? 0,
            height: rows.last.map { $0.originY + $0.height } ?? 0
        )
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        let rows = makeRows(
            proposal: ProposedViewSize(width: bounds.width, height: proposal.height),
            subviews: subviews
        )

        for row in rows {
            var x = bounds.minX

            for item in row.items {
                subviews[item.index].place(
                    at: CGPoint(x: x, y: bounds.minY + row.originY),
                    proposal: ProposedViewSize(item.size)
                )
                x += item.size.width + horizontalSpacing
            }
        }
    }

    private func makeRows(
        proposal: ProposedViewSize,
        subviews: Subviews
    ) -> [Row] {
        let maxWidth = proposal.width ?? .infinity
        var rows: [Row] = []
        var currentRow = Row()

        for index in subviews.indices {
            let size = subviews[index].sizeThatFits(.unspecified)
            let nextWidth = currentRow.items.isEmpty
                ? size.width
                : currentRow.width + horizontalSpacing + size.width

            if nextWidth > maxWidth, !currentRow.items.isEmpty {
                rows.append(currentRow)
                currentRow = Row(originY: currentRow.originY + currentRow.height + verticalSpacing)
            }

            currentRow.items.append(
                Item(
                    index: index,
                    size: size
                )
            )
            currentRow.width = currentRow.items.count == 1
                ? size.width
                : currentRow.width + horizontalSpacing + size.width
            currentRow.height = max(currentRow.height, size.height)
        }

        if !currentRow.items.isEmpty {
            rows.append(currentRow)
        }

        return rows
    }
}

private struct Row {
    var items: [Item] = []
    var width: CGFloat = 0
    var height: CGFloat = 0
    var originY: CGFloat = 0
}

private struct Item {
    let index: Int
    let size: CGSize
}
