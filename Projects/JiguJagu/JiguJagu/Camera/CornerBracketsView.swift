//
//  CornerbracketsView.swift
//  JiguJagu
//
//  Created by SIA on 7/18/26.
//

import SwiftUI

/// 촬영 영역을 안내하는 네 모서리 L자 브래킷.
struct CornerBracketsView: View {
    var color: Color = .white
    var lineWidth: CGFloat = 3
    var cornerLength: CGFloat = 26

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            Path { path in
                // 좌상단
                path.move(to: CGPoint(x: 0, y: cornerLength))
                path.addLine(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: cornerLength, y: 0))

                // 우상단
                path.move(to: CGPoint(x: w - cornerLength, y: 0))
                path.addLine(to: CGPoint(x: w, y: 0))
                path.addLine(to: CGPoint(x: w, y: cornerLength))

                // 우하단
                path.move(to: CGPoint(x: w, y: h - cornerLength))
                path.addLine(to: CGPoint(x: w, y: h))
                path.addLine(to: CGPoint(x: w - cornerLength, y: h))

                // 좌하단
                path.move(to: CGPoint(x: cornerLength, y: h))
                path.addLine(to: CGPoint(x: 0, y: h))
                path.addLine(to: CGPoint(x: 0, y: h - cornerLength))
            }
            .stroke(color,
                    style: StrokeStyle(lineWidth: lineWidth,
                                       lineCap: .square,
                                       lineJoin: .miter))
        }
    }
}
