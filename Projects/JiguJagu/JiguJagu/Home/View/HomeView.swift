//
//  HomeView.swift
//  JiguJagu
//
//  Created by SIA on 7/16/26.
//

import SwiftUI

struct HomeView: View {
    @State private var showCamera = false
    @State private var selectedTicket: ArchiveCategory.HomeTicket?

    /// 상단 여백. 값을 키우면 로고를 포함한 전체 UI가 함께 아래로 내려갑니다.
    private let contentTopPadding: CGFloat = 101

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                titleSection
                ticketGrid
                Spacer()
                addButton
                    .padding(.leading, 16)
            }
            .padding(.horizontal)
            .background {
                ZStack {
                    Image("MainBG")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 532, height: 912)
                        .clipped()

                    VStack(spacing: 0) {
                        TopGradientOverlay()
                            .blendMode(.multiply)
                        Spacer(minLength: 0)
                    }
                }
            }
            .navigationDestination(item: $selectedTicket) { ticket in
                ArchiveView(
                    initialCategory: ticket.archiveCategory,
                    onBackButtonTap: { selectedTicket = nil }
                )
                .navigationBarBackButtonHidden(true)
                .toolbar(.hidden, for: .navigationBar)
            }
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
        .padding(.top, contentTopPadding)
        .padding(.leading, 16)
        .ignoresSafeArea()
    }
    
    private var ticketGrid: some View {
        HStack(alignment: .top, spacing: 26) {
            VStack(spacing: 21) {
                CategoryTicketButton(title: "TOP", imageName: "TopButton") {
                    selectedTicket = .top
                }
                CategoryTicketButton(title: "OUTER", imageName: "OuterButton") {
                    selectedTicket = .outer
                }
            }
            
            VStack(spacing: 21) {
                CategoryTicketButton(title: "BOTTOM", imageName: "BottomButton") {
                    selectedTicket = .bottom
                }
                CategoryTicketButton(title: "ALL", imageName: "AllButton") {
                    selectedTicket = .all
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
                .frame(maxWidth: 335)
                .padding(.vertical, 13)
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
