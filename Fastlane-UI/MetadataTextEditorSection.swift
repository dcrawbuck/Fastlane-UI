//
//  MetadataTextEditorSection.swift
//  Fastlane-UI
//
//  Created by Duncan Crawbuck on 2/18/25.
//

import SwiftUI

extension Font {
    var lineHeight: CGFloat {
        let nsFont = NSFont.preferredFont(forTextStyle: .body)
        return nsFont.ascender - nsFont.descender + nsFont.leading
    }
}

struct MetadataTextEditorSection: View {
    
    var label: String? = nil
    @Binding var text: String
    // Local state to track changes
    @State private var localText: String
    var lines: Int? = nil
    var maxCharacters: Int? = nil
    
    private var charactersLeft: Int? {
        if let maxCharacters {
            return maxCharacters - localText.count
        }
        return nil
    }
    private let font: Font = .system(.body, design: .monospaced)
    
    init(label: String? = nil, text: Binding<String>, lines: Int? = nil, maxCharacters: Int? = nil) {
        self.label = label
        self._text = text
        self._localText = State(initialValue: text.wrappedValue)
        self.lines = lines
        self.maxCharacters = maxCharacters
    }
    
    private var height: CGFloat? {
        if let lines = lines {
            return font.lineHeight * CGFloat(lines)
        }
        return nil
    }
    
    var body: some View {
        Section(
            content: {
                TextEditor(text: $localText)
                    .font(font)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .frame(height: height)
                    .onChange(of: localText, initial: true) {
                        // update the binding value with the local state
                        text = localText
                    }
                    .onChange(of: text) {
                        // update the local state with the binding value
                        localText = text
                    }
            },
            header: {
                if let label {
                    Text(label)
                }
            },
            footer: {
                if let charactersLeft {
                    Text("\(charactersLeft)")
                        .foregroundStyle(charactersLeft >= 0 ? Color.secondary : Color.red)
                }
            }
        )
    }
}

#Preview {
    Form {
        MetadataTextEditorSection(
            label: "Description",
            text: .constant("Hello, World!"),
            lines: 5,
            maxCharacters: 100
        )
    }
    .formStyle(.grouped)
}

#Preview("Max Characters Exceeded") {
    Form {
        MetadataTextEditorSection(
            label: "Description",
            text: .constant("Hello, World!"),
            lines: 5,
            maxCharacters: 5
        )
    }
    .formStyle(.grouped)
}

#Preview("No Line or Character Limit") {
    Form {
        MetadataTextEditorSection(
            label: "Description",
            text: .constant("Hello, World!\nNew Line")
        )
    }
    .formStyle(.grouped)
}
