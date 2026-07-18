//
//  HomeView.swift
//  JiguJagu
//
//  Created by SIA on 7/16/26.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            titleSection
            Spacer()
            ticketGrid
            Spacer()
            addButton
        }
        .padding(.horizontal)
        .background {
            Image("wall")
                .resizable()
                .scaledToFill()
                .offset(x: -34)
                .ignoresSafeArea()
        }
    }
}

// MARK: - Subviews
extension HomeView {

    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("오래입자구")
                .font(.system(size: 46, weight: .black))
                .foregroundStyle(.white)

            Text("Good for Earth, Good for Environment")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.white)

            Text("오래 입는 습관의 시작, 지속가능한 미래와 가까워지다")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.white)
        }
        .padding(.top, 30)
    }

    private var ticketGrid: some View {
        HStack(alignment: .top, spacing: 26) {
            VStack(spacing: 21) {
                CategoryTicketButton(title: "TOP", imageName: "TopButton") {
                    // TODO
                }
                CategoryTicketButton(title: "OUTER", imageName: "OuterButton") {
                    // TODO
                }
            }

            VStack(spacing: 21) {
                CategoryTicketButton(title: "BOTTOM", imageName: "BottomButton") {
                    // TODO
                }
                CategoryTicketButton(title: "ALL", imageName: "AllButton") {
                    // TODO
                }
            }
            .padding(.top, 40)
        }
        .frame(maxWidth: .infinity)
    }

    private var addButton: some View {
        Button {
            // TODO: add action
        } label: {
            Text("Add")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Color.white)
                .clipShape(Capsule())
        }
        .padding(.bottom, 40)
    }
}

#Preview {
    HomeView()
}
