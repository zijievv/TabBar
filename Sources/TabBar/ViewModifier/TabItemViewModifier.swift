//
//  TabItemViewModifier.swift
//
//
//  Created by Zijie on 18.05.2023.
//  Copyright © 2023 Zijie. All rights reserved.
//
//  ====================================================================================================================
//

import SwiftUI

struct TabItemViewModifier<Selection: Hashable, V: View>: ViewModifier {
    @Environment(\.tabItemSelectionHashValue) private var selectionHashValue
    private let item: Selection
    @ViewBuilder private let itemBuilder: () -> V

    init(item: Selection, @ViewBuilder itemBuilder: @escaping () -> V) {
        self.item = item
        self.itemBuilder = itemBuilder
    }

    func body(content: Content) -> some View {
        Group {
            if selectionHashValue == item.hashValue {
                content
            } else {
                Color.clear
            }
        }
        .preference(key: ItemsPreferenceKey.self, value: [item])
        .preference(
            key: ItemViewBuilderPreferenceKey.self,
            value: [item: .init(content: { AnyView(VStack(content: itemBuilder)) })]
        )
    }
}

extension View {
    public func tabItem<Selection: Hashable, V: View>(
        _ selection: Selection,
        @ViewBuilder label: @escaping () -> V
    ) -> some View {
        modifier(TabItemViewModifier(item: selection, itemBuilder: label))
    }
}
