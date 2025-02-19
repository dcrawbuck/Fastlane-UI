//
//  ContentView.swift
//  Fastlane-UI
//
//  Created by Duncan Crawbuck on 2/17/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State var selectedProject: ProjectModel?
    @State var selectedItem: ProjectSublistItem? = .metadata
    
    var body: some View {
        if selectedProject == nil {
            ContentUnavailableView(
                label: {
                    Label("No Project Open", systemImage: "folder")
                },
                actions: {
                    Button(
                        action: openProject,
                        label: {
                            Text("Open Project")
                        }
                    )
                }
            )
        }
        else {
            NavigationSplitView(
                sidebar: {
                    ProjectSubListView(selectedItem: $selectedItem)
                },
                detail: {
                    if let selectedItem,
                       let selectedProject {
                        switch selectedItem {
                        case .metadata:
                            MetadataView(
                                projectModel: selectedProject
                            )
                        }
                    }
                }
            )
            .toolbar {
                ToolbarItem {
                    Button(
                        action: openProject,
                        label: {
                            Label("Open Project", systemImage: "folder")
                        }
                    )
                }
            }
        }
    }
    
    func openProject() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        
        Task {
            await panel.begin()
            guard let url = panel.url else {
                return
            }
            await MainActor.run {
                selectedProject = ProjectModel(filepath: url)
            }
        }
    }
}

#Preview("No Project Open") {
    ContentView()
}

#Preview("Project Open") {
    ContentView(
        selectedProject: ProjectModel(filepath: URL(filePath: "/"))
    )
}
