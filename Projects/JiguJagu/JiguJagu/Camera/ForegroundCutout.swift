//
//  ForegroundCutout.swift
//  JiguJagu
//
//  Created by SIA on 7/22/26.
//

import UIKit
import Vision
import CoreImage

// MARK: - Foreground Cutout

/// Vision 프레임워크로 사진에서 피사체(전경)만 분리(누끼)합니다.
///
/// 확인 화면에서 "배경은 어둡게 / 피사체는 그대로" 효과를 만들기 위해,
/// 배경이 투명하게 제거된 피사체 이미지를 반환합니다.
enum ForegroundCutout {

    /// 원본 이미지에서 피사체만 남기고 배경을 투명하게 제거한 이미지를 반환합니다.
    ///
    /// - 반환 이미지는 orientation이 `.up`으로 정규화되어 있어,
    ///   같은 프레임에 원본(정규화본)과 겹쳐 그리면 정확히 정렬됩니다.
    /// - 피사체를 찾지 못하거나 처리에 실패하면 `nil`을 반환합니다.
    ///   (호출부에서 원본만 표시하는 fallback 처리를 권장)
    static func extract(from image: UIImage) async -> UIImage? {
        // 무거운 Vision 연산은 백그라운드에서 수행
        await Task.detached(priority: .userInitiated) {
            let upright = image.normalizedUp()
            guard let cgImage = upright.cgImage else { return nil }

            let request = VNGenerateForegroundInstanceMaskRequest()
            let handler = VNImageRequestHandler(cgImage: cgImage, orientation: .up)

            do {
                try handler.perform([request])

                guard let observation = request.results?.first else {
                    return nil  // 전경 인스턴스를 찾지 못함
                }

                // 감지된 모든 전경 인스턴스를 하나의 마스크로 합쳐 잘라냅니다.
                let maskedBuffer = try observation.generateMaskedImage(
                    ofInstances: observation.allInstances,
                    from: handler,
                    croppedToInstancesExtent: false  // 원본과 크기 동일하게 유지 → 정렬 보장
                )

                let ciImage = CIImage(cvPixelBuffer: maskedBuffer)
                let context = CIContext()
                guard let outputCG = context.createCGImage(ciImage, from: ciImage.extent) else {
                    return nil
                }

                return UIImage(cgImage: outputCG,
                               scale: upright.scale,
                               orientation: .up)
            } catch {
                return nil
            }
        }.value
    }
}

// MARK: - UIImage Orientation

extension UIImage {

    /// orientation을 `.up`으로 정규화한 이미지를 반환합니다.
    ///
    /// 카메라로 촬영한 `UIImage`는 픽셀 방향과 표시 방향이 다를 수 있는데,
    /// `.cgImage`는 orientation을 적용하지 않은 원시 픽셀을 돌려줍니다.
    /// 누끼 마스크를 원본과 정확히 겹치려면 두 이미지의 픽셀 방향이 같아야 하므로,
    /// 미리 화면에 보이는 방향 그대로 다시 그려 둡니다.
    func normalizedUp() -> UIImage {
        guard imageOrientation != .up else { return self }

        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        format.opaque = false

        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
