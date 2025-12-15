//
//  RulerSlider.swift
//  musubi
//
//  Created by Kish Dizon on 2025-12-14.
//

import SwiftUI

struct RulerSlider: View {
    @Binding var value: Int
    let range: ClosedRange<Int>
    var accentColor: Color = .white

    private let tickWidth: CGFloat = 8
    private let tickSpacing: CGFloat = 8
    private let minorTickHeight: CGFloat = 12
    private let majorTickHeight: CGFloat = 20
    private let totalHeight: CGFloat = 50

    private var tickStep: CGFloat { tickWidth + tickSpacing }

    @State private var scrolledID: Int?

    var body: some View {
        if #available(macOS 14.0, *) {
            modernRulerSlider
        } else {
            legacyRulerSlider
        }
    }

    @available(macOS 14.0, *)
    private var modernRulerSlider: some View {
        GeometryReader { geometry in
            let halfWidth = geometry.size.width / 2

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: tickSpacing) {
                    ForEach(range, id: \.self) { minute in
                        TickMark(
                            minute: minute,
                            isMajor: minute % 10 == 0,
                            isSelected: minute == scrolledID,
                            accentColor: accentColor,
                            minorHeight: minorTickHeight,
                            majorHeight: majorTickHeight
                        )
                        .id(minute)
                    }
                }
                .scrollTargetLayout()
                .padding(.horizontal, halfWidth)
            }
            .scrollPosition(id: $scrolledID, anchor: .center)
            .scrollTargetBehavior(NearestTickBehavior(tickStep: tickStep, tickCount: range.count))
            .onChange(of: scrolledID) { _, newValue in
                if let newValue, newValue != value {
                    value = newValue
                }
            }
            .onChange(of: value) { _, newValue in
                if scrolledID != newValue {
                    scrolledID = newValue
                }
            }
            .onAppear {
                scrolledID = value
            }
        }
        .frame(height: totalHeight)
    }

    private var legacyRulerSlider: some View {
        GeometryReader { geometry in
            let halfWidth = geometry.size.width / 2

            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: tickSpacing) {
                        ForEach(range, id: \.self) { minute in
                            TickMark(
                                minute: minute,
                                isMajor: minute % 10 == 0,
                                isSelected: minute == value,
                                accentColor: accentColor,
                                minorHeight: minorTickHeight,
                                majorHeight: majorTickHeight
                            )
                            .id(minute)
                            .onTapGesture {
                                value = minute
                                withAnimation {
                                    proxy.scrollTo(minute, anchor: .center)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, halfWidth)
                }
                .onAppear {
                    proxy.scrollTo(value, anchor: .center)
                }
                .onChange(of: value) { newValue in
                    withAnimation {
                        proxy.scrollTo(newValue, anchor: .center)
                    }
                }
            }
        }
        .frame(height: totalHeight)
    }
}

@available(macOS 14.0, *)
private struct NearestTickBehavior: ScrollTargetBehavior {
    let tickStep: CGFloat
    let tickCount: Int

    func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
        // Calculate which tick the scroll is nearest to
        let offset = target.rect.minX
        let tickIndex = round(offset / tickStep)
        let clampedIndex = max(0, min(CGFloat(tickCount - 1), tickIndex))
        let snappedOffset = clampedIndex * tickStep

        target.rect.origin.x = snappedOffset
    }
}

private struct TickMark: View {
    let minute: Int
    let isMajor: Bool
    let isSelected: Bool
    let accentColor: Color
    let minorHeight: CGFloat
    let majorHeight: CGFloat

    private var tickColor: Color {
        isSelected ? accentColor : .gray
    }

    var body: some View {
        Rectangle()
            .fill(tickColor)
            .frame(width: isSelected ? 2 : (isMajor ? 2 : 1), height: isMajor ? majorHeight : minorHeight)
            .frame(width: 8, height: majorHeight + 14, alignment: .top)
            .overlay(alignment: .bottom) {
                if isMajor {
                    Text("\(minute)")
                        .font(.system(size: 9))
                        .foregroundColor(isSelected ? accentColor : .gray)
                        .fixedSize()
                }
            }
    }
}

@available(macOS 14.0, *)
#Preview {
    @Previewable @State var minutes = 25
    VStack {
        RulerSlider(value: $minutes, range: 0...120)
        Text("Selected: \(minutes) minutes")
    }
    .padding()
    .frame(width: 280)
}
