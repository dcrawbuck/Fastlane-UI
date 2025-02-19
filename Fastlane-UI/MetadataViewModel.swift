//
//  MetadataViewModel.swift
//  Fastlane-UI
//
//  Created by Duncan Crawbuck on 2/18/25.
//

import Foundation
import SwiftUI

class MetadataViewModel: ObservableObject {
    
    @FileBacked var description: String
    @FileBacked var keywords: String
    @FileBacked var marketingUrl: String
    @FileBacked var name: String
    @FileBacked var privacyUrl: String
    @FileBacked var promotionalText: String
    @FileBacked var releaseNotes: String
    @FileBacked var subtitle: String
    @FileBacked var supportUrl: String
    
    private let projectModel: ProjectModel
    private let enUSFilepath: URL
    
    init(projectModel: ProjectModel) {
        self.projectModel = projectModel
        self.enUSFilepath = projectModel.filepath.appendingPathComponent("fastlane/metadata/en-US")
        
        self._description = FileBacked(fileURL: enUSFilepath.appendingPathComponent("description.txt"))
        self._keywords = FileBacked(fileURL: enUSFilepath.appendingPathComponent("keywords.txt"))
        self._marketingUrl = FileBacked(fileURL: enUSFilepath.appendingPathComponent("marketing_url.txt"))
        self._name = FileBacked(fileURL: enUSFilepath.appendingPathComponent("name.txt"))
        self._privacyUrl = FileBacked(fileURL: enUSFilepath.appendingPathComponent("privacy_url.txt"))
        self._promotionalText = FileBacked(fileURL: enUSFilepath.appendingPathComponent("promotional_text.txt"))
        self._releaseNotes = FileBacked(fileURL: enUSFilepath.appendingPathComponent("release_notes.txt"))
        self._subtitle = FileBacked(fileURL: enUSFilepath.appendingPathComponent("subtitle.txt"))
        self._supportUrl = FileBacked(fileURL: enUSFilepath.appendingPathComponent("support_url.txt"))
    }
    
    func reload() {
        [
            _description,
            _keywords,
            _marketingUrl,
            _name,
            _privacyUrl,
            _promotionalText,
            _releaseNotes,
            _subtitle,
            _supportUrl,
        ].forEach { $0.reload() }
        
        // tell SwiftUI to update the UI
        objectWillChange.send()
    }
}

@propertyWrapper
final class FileBacked {
    private let fileURL: URL
    private var value: String
    
    var wrappedValue: String {
        get { value }
        set {
            value = newValue
            save()
        }
    }
    
    var projectedValue: Binding<String> {
        Binding<String>(
            get: { [weak self] in self?.value ?? "" },
            set: { [weak self] newValue in
                self?.wrappedValue = newValue
            }
        )
    }
    
    init(fileURL: URL, defaultValue: String = "") {
        self.fileURL = fileURL
        self.value = (try? String(contentsOf: fileURL)) ?? defaultValue
    }
    
    func reload() {
        value = (try? String(contentsOf: fileURL)) ?? ""
    }
    
    private func save() {
        do {
            try value.write(to: fileURL, atomically: true, encoding: .utf8)
        }
        catch {
            print("Error saving \(fileURL.lastPathComponent): \(error)")
        }
    }
}
