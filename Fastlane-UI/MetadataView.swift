//
//  MetadataView.swift
//  Fastlane-UI
//
//  Created by Duncan Crawbuck on 2/17/25.
//

import SwiftUI

struct MetadataView: View {
    
    @ObservedObject var viewModel: MetadataViewModel
    
    init(projectModel: ProjectModel) {
        self.viewModel = MetadataViewModel(projectModel: projectModel)
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $viewModel.name)
                TextField("Subtitle", text: $viewModel.subtitle)
            }
            
            MetadataTextEditorSection(
                label: "Promotional Text",
                text: $viewModel.promotionalText,
                lines: 5,
                maxCharacters: 170
            )
            
            MetadataTextEditorSection(
                label: "Description",
                text: $viewModel.description,
                lines: 5,
                maxCharacters: 4_000
            )

            MetadataTextEditorSection(
                label: "Release Notes",
                text: $viewModel.releaseNotes,
                lines: 5,
                maxCharacters: 4_000
            )
            
            MetadataTextEditorSection(
                label: "Keywords",
                text: $viewModel.keywords,
                maxCharacters: 100
            )
            
            Section {
                MetadataURLTextField(
                    label: "Marketing URL",
                    url: $viewModel.marketingUrl
                )
                MetadataURLTextField(
                    label: "Support URL",
                    url: $viewModel.supportUrl
                )
                MetadataURLTextField(
                    label: "Privacy URL",
                    url: $viewModel.privacyUrl
                )
            }
        }
        .formStyle(.grouped)
        .frame(minWidth: 300, minHeight: 400)
        .toolbar {
            Button(
                action: viewModel.reload,
                label: {
                    Label("Reload", systemImage: "arrow.counterclockwise")
                }
            )
        }
    }
}

#Preview {
    MetadataView(projectModel: ProjectModel(filepath: URL(filePath: "/")))
}

struct MetadataURLTextField: View {
    
    var label: String
    @Binding var url: String
    
    var body: some View {
        HStack {
            TextField(label, text: $url)
            
            Button(
                action: {
                    if let url = URL(string: url) {
                        NSWorkspace.shared.open(url)
                    }
                },
                label: {
                    Label("Open", systemImage: "safari")
                        .labelStyle(.iconOnly)
                }
            )
            .buttonStyle(.borderless)
        }
    }
}
