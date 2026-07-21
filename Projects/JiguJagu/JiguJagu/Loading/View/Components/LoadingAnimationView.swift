//
//  LoadingAnimationView.swift
//  JiguJagu
//
//  Created by mason on 7/21/26.
//

import SwiftUI

struct LoadingAnimationView: View {
    @State private var orbitPulseOpacity = 1.0
    @State private var orbitProgress = 0.0

    var body: some View {
        ZStack {
            Image("LoadingOrbitSecondary")
                .resizable()
                .scaledToFit()
                .frame(width: 196, height: 136)
                .rotationEffect(.degrees(-2))
                .offset(x: 8, y: 4)
                .opacity(orbitPulseOpacity)
                .zIndex(0)

            Image("LoadingOrbitPrimary")
                .resizable()
                .scaledToFit()
                .frame(width: 215, height: 131)
                .rotationEffect(.degrees(-2))
                .offset(x: 4, y: 2)
                .opacity(orbitPulseOpacity)
                .zIndex(0)

            Image("LoadingEarthIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 78, height: 76)
                .offset(x: 0, y: 7)
                .zIndex(1)

            Image("LoadingShirtIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 34)
                .rotationEffect(.degrees(-14))
                .modifier(
                    MobiusOrbitMotionModifier(
                        progress: orbitProgress,
                        phase: 0,
                        radiusX: 98,
                        radiusY: 68,
                        centerOffset: CGSize(width: 8, height: 4),
                        startDegrees: 225,
                        orbitRotationDegrees: -2
                    )
                )

            Image("LoadingMagnifierIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 27, height: 38)
                .rotationEffect(.degrees(15))
                .modifier(
                    MobiusOrbitMotionModifier(
                        progress: orbitProgress,
                        phase: 0.5,
                        radiusX: 107.5,
                        radiusY: 65.5,
                        centerOffset: CGSize(width: 4, height: 2),
                        startDegrees: 225,
                        orbitRotationDegrees: -2
                    )
                )
        }
        .frame(width: 247, height: 205)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("의류 검색 로딩 애니메이션")
        .onAppear {
            startAnimationLoop()
        }
    }
}

private extension LoadingAnimationView {
    func startAnimationLoop() {
        withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
            orbitPulseOpacity = 0.75
        }

        orbitProgress = 0
        withAnimation(.linear(duration: 5.6).repeatForever(autoreverses: false)) {
            orbitProgress = 1
        }
    }
}

private struct MobiusOrbitMotionModifier: AnimatableModifier {
    var progress: Double
    let phase: Double
    let radiusX: CGFloat
    let radiusY: CGFloat
    let centerOffset: CGSize
    let startDegrees: Double
    let orbitRotationDegrees: Double

    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }

    func body(content: Content) -> some View {
        content
            .scaleEffect(depthScale)
            .opacity(depthOpacity)
            .offset(x: offsetX, y: offsetY)
            .zIndex(depthZIndex)
    }
}

private extension MobiusOrbitMotionModifier {
    var normalizedProgress: Double {
        (progress + phase).truncatingRemainder(dividingBy: 1)
    }

    var orbitAngle: Double {
        (startDegrees + normalizedProgress * 360) * .pi / 180
    }

    var orbitRotationAngle: Double {
        orbitRotationDegrees * .pi / 180
    }

    var rawOffsetX: CGFloat {
        cos(orbitAngle) * radiusX
    }

    var rawOffsetY: CGFloat {
        sin(orbitAngle) * radiusY
    }

    var offsetX: CGFloat {
        centerOffset.width + rawOffsetX * cos(orbitRotationAngle) - rawOffsetY * sin(orbitRotationAngle)
    }

    var offsetY: CGFloat {
        centerOffset.height + rawOffsetX * sin(orbitRotationAngle) + rawOffsetY * cos(orbitRotationAngle)
    }

    var frontDepth: Double {
        (sin(orbitAngle) + 1) / 2
    }

    var depthScale: CGFloat {
        0.88 + frontDepth * 0.18
    }

    var depthOpacity: Double {
        0.58 + frontDepth * 0.42
    }

    var depthZIndex: Double {
        -0.5 + frontDepth * 3
    }
}

#Preview {
    LoadingAnimationView()
        .padding()
        .background(Color.white)
}
