//
//  ProjectSubListView.swift
//  Fastlane-UI
//
//  Created by Duncan Crawbuck on 2/17/25.
//

import SwiftUI

enum ProjectSublistItem: CaseIterable {
    case metadata
    
    var title: String {
        switch self {
        case .metadata:
            return "Metadata"
        }
    }
    var systemImage: String {
        switch self {
        case .metadata:
            return "text.alignleft"
        }
    }
}

struct ProjectSubListView: View {
    
    @Binding var selectedItem: ProjectSublistItem?
    
    var body: some View {
        List(selection: $selectedItem) {
            ForEach(ProjectSublistItem.allCases, id: \.self) { item in
                NavigationLink(value: item) {
                    Label(item.title, systemImage: item.systemImage)
                }
            }
            Text("More coming soon...")
                .foregroundStyle(.secondary)
        }
        .listStyle(.sidebar)
    }
}

#Preview {
    ProjectSubListView(
        selectedItem: .constant(.metadata)
    )
}
