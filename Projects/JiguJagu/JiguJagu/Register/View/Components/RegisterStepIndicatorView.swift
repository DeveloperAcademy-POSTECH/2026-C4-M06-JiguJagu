//
//  RegisterStepIndicatorView.swift
//  JiguJagu
//
//  Created by Codex on 7/21/26.
//

import SwiftUI

struct RegisterStepIndicatorView: View {
    let currentStep: Int
    let totalSteps: Int

    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...totalSteps, id: \.self) { step in
                stepMarker(for: step)

                if step < totalSteps {
                    stepConnector
                }
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("등록 단계 \(currentStep) / \(totalSteps)")
    }

    private func stepMarker(for step: Int) -> some View {
        Group {
            if step == currentStep {
                Text("\(step)")
                    .font(.pretendard.body2)
                    .foregroundStyle(.white)
                    .frame(width: 24, height: 24)
                    .background(Color.primary400)
                    .clipShape(Circle())
            } else {
                Circle()
                    .stroke(Color.grayScale400, lineWidth: 3)
                    .frame(width: 16, height: 16)
            }
        }
    }

    private var stepConnector: some View {
        HStack(spacing: 4) {
            ForEach(0..<6, id: \.self) { _ in
                Rectangle()
                    .fill(Color.grayScale400)
                    .frame(width: 4, height: 2)
            }
        }
    }
}

#Preview {
    RegisterStepIndicatorView(currentStep: 1, totalSteps: 3)
        .padding()
}
