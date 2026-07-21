//
//  HomeView.swift
//  JiguJagu
//
//  Created by SIA on 7/16/26.
//

import SwiftUI

struct HomeView: View {
    @State private var showCamera = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            titleSection
            ticketGrid
            Spacer()
            addButton
        }
        .padding(.horizontal)
        .background {
            Image("MainBG")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 532, height: 912)
                .clipped()
        }
    }
}

// MARK: - Subviews
extension HomeView {
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image("WhiteLogo")
            
            Text("Good for Earth, Good for Environment")
                .font(.arial.sub1)
                .foregroundStyle(.white)
            
            Text("오래 입는 습관의 시작, 지속가능한 미래와 가까워지다")
                .font(.pretendard.body5)
                .foregroundStyle(.white)
        }
        .padding(.top, 79)
        .padding(.leading, 16)
        .ignoresSafeArea()
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
            .padding(.top, 64)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var addButton: some View {
        Button {
            showCamera = true
        } label: {
            Text("옷 등록")
                .font(.pretendard.head3)
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Color.white)
                .clipShape(Capsule())
        }
        .padding(.bottom, 40)
        .fullScreenCover(isPresented: $showCamera) {
            LaundryCaptureFlow()
        }
    }
}

#Preview {
    HomeView()
}
