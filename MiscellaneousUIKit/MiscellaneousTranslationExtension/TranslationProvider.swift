//
//  TranslationProvider.swift
//  MiscellaneousTranslationExtension
//
//  Created by Jinwoo Kim on 2/24/25.
//

import SwiftUI
import TranslationUIProvider

@main
class TranslationProviderExtension: TranslationUIProviderExtension {

    required init() {
    }

    var body: some TranslationUIProviderExtensionScene {
        TranslationUIProviderSelectedTextScene { session in
            NavigationStack {
                TranslationProviderView(session: session)
            }
        }
    }
}

struct TranslationProviderView: View {
    @State var session: TranslationUIProviderContext
    @State var translated: String = ""

    init(session s: TranslationUIProviderContext) {
        session = s
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(session.inputText ?? "")
            Text(translated)
            Button(action: translate) {
                Label("Translate", systemImage: "translate")
            }
            Button(action: replaceText) {
                Text("Replace With Translation")
            }.disabled(!session.allowsReplacement)
        }.padding(8)
    }

    private func translate() {
        if let totranslate = session.inputText, !totranslate.characters.isEmpty {
            // Here a developer would call their own translation API:
            translated = String(totranslate.characters.reversed())
        }
    }

    private func replaceText() {
        session.finish(translation: AttributedString(translated))
    }

}
