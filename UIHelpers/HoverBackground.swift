//
//  HoverBackground.swift
//  musubi
//
//  Created by Kish Dizon on 2025-11-12.
//
import SwiftUI

struct HoverBackground: ViewModifier {
    @State private var hovering = false
    var color: Color = .gray.opacity(0.15)
    var radius: CGFloat = 6
    var insets = EdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4)

    func body(content: Content) -> some View {
        content
            .padding(insets)
            .background(
                RoundedRectangle(cornerRadius: radius)
                    .fill(hovering ? color : .clear)
            )
            .contentShape(Rectangle())
            .onHover { hovering = $0 }
            .animation(.easeInOut(duration: 0.15), value: hovering)
    }
}
extension View {
    func hoverBackground(
        color: Color = .gray.opacity(0.15),
        radius: CGFloat = 6
    ) -> some View {
        modifier(HoverBackground(color: color, radius: radius))
    }
}
