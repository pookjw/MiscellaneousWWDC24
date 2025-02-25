//
//  ImageCreatorView.swift
//  MyApp
//
//  Created by Jinwoo Kim on 2/25/25.
//

import SwiftUI
import ImagePlayground
import PencilKit

@available(iOS 18.4, *)
struct ImageCreatorView: View {
    @State private var imageCreator: ImageCreator?
    
    @State private var concepts: [ConceptWrapper] = [
        ConceptWrapper(concept: .text("Apple"))
    ]
    @State private var style: ImagePlaygroundStyle = .sketch
    
    @State private var text = ""
    @State private var isTextAlertPresented = false
    
    @State private var inProgress = false
    @State private var createdImages: [ImageCreator.CreatedImage] = []
    
    var body: some View {
        Form {
            Section("Concepts") {
                ForEach(concepts) { concept in
                    Text(concept.description)
                }
                .onDelete { indexSet in
                    concepts.remove(atOffsets: indexSet)
                }
            }
            
            if let availableStyles = imageCreator?.availableStyles {
                Section {
                    Picker(style.id, selection: $style) {
                        ForEach(availableStyles) { style in
                            Button(style.id) {
                                self.style = style
                            }
                        }
                    }
                }
            }
            
            Section {
                if inProgress {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    Button("Create") {
                        createdImages.removeAll()
                        inProgress = true
                    }
                }
            }
            
            Section("Results") {
                ForEach(createdImages, id: \.cgImage) { image in
                    Image(uiImage: UIImage(cgImage: image.cgImage))
                        .resizable()
                              .aspectRatio(contentMode: .fit)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button("Add Text") {
                        text = ""
                        isTextAlertPresented = true
                    }
                } label: {
                    Label("Add", systemImage: "plus")
                }
            }
        }
        .alert("Add Concept", isPresented: $isTextAlertPresented) {
            TextField("", text: $text)
            Button("OK") {
                concepts.append(ConceptWrapper(concept: .text(text)))
            }
        }
        .task {
            if imageCreator == nil {
                imageCreator = try! await ImageCreator()
                
                for child in Mirror(reflecting: imageCreator.unsafelyUnwrapped).children {
                    print(child)
                }
            }
        }
        .task(id: inProgress) {
            guard inProgress else { return }
            defer { inProgress = false }
            
            let imageCreator = imageCreator!
            let concepts = concepts.map { $0.concept}
            
            do {
                let stream = imageCreator.images(for: concepts, style: style, limit: .max)
                for try await image in stream {
                    createdImages.append(image)
                }
            } catch {
                print(error)
            }
        }
    }
}

fileprivate struct ConceptWrapper: Hashable, Identifiable, CustomStringConvertible {
    enum Element: Hashable {
        case text(String)
        case extraced(from: String, title: String?)
        case drawing(PKDrawing)
        case cgImage(CGImage)
        case imageURL(URL)
        
        func hash(into hasher: inout Hasher) {
            switch self {
            case .text(let text):
                hasher.combine(0)
                hasher.combine(text)
            case .extraced(let from, let title):
                hasher.combine(1 << 0)
                hasher.combine(from)
                hasher.combine(title)
            case .drawing(let drawing):
                hasher.combine(1 << 1)
                hasher.combine(drawing as PKDrawingReference)
            case .cgImage(let image):
                hasher.combine(1 << 2)
                hasher.combine(image)
            case .imageURL(let url):
                hasher.combine(1 << 3)
                hasher.combine(url)
            }
        }
    }
    
    let concept: ImagePlaygroundConcept
    
    var element: Element {
        unsafeBitCast(concept, to: Element.self)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(element)
    }
    
    static func == (lhs: ConceptWrapper, rhs: ConceptWrapper) -> Bool {
        return lhs.element == rhs.element
    }
    
    var id: Int {
        element.hashValue
    }
    
    var description: String {
        switch element {
        case .text(let string):
            return "Text: \(string)"
        case .extraced(let from, let title):
            return "Extraced: (from: \(from), title: \(title ?? "nil"))"
        case .drawing(let drawing):
            return "Drawing: \(drawing)"
        case .cgImage(let image):
            return "CGImage: \(image)"
        case .imageURL(let url):
            return "Image URL: \(url)"
        }
    }
}

@available(iOS 18.4, *)
#Preview {
    ImageCreatorView()
}
