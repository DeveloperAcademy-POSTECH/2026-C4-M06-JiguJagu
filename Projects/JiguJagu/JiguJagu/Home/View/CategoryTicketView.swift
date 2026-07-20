//
//  CategoryTicket.swift
//  JiguJagu
//
//  Created by SIA on 7/16/26.
//
import SwiftUI

struct CategoryTicketButton: View {
    let title: String
    let imageName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .topLeading) {
                Image(imageName)
                    .resizable()
                    .scaledToFit()

                Text(title)
//                    .font(.system(size: 18, weight: .heavy))
                    .font(.pretendard.body1)
                    .foregroundStyle(.black)
                    .padding(13)
            }
            .frame(width: 154, height: 157)
        }
        .buttonStyle(.plain)
    }
}
