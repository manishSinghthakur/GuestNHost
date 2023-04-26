//
//  CacheAsyncImage.swift
//  Nisumapp (iOS)
//
//  Created by nisum on 21/03/22.
//  Copyright © 2022 Nisum. All rights reserved.
//

import SwiftUI

@available(iOS 15.0, *)
struct CacheAsyncImage<Content>: View where Content: View {

    private let url: URL
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content

    @available(iOS 15.0, *)
    init(
        url: URL,
        scale: CGFloat = 1.0,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ) {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
    }

    @available(iOS 15.0, *)
    var body: some View {

        if let cached = ImageCache[url] {
//            let _ = print("cached \(url.absoluteString)")
            content(.success(cached))
        } else {
//            let _ = print("request \(url.absoluteString)")
            AsyncImage(
                url: url,
                scale: scale,
                transaction: transaction
            ) { phase in
                cacheAndRender(phase: phase)
            }
        }
    }

    @available(iOS 15.0, *)
    func cacheAndRender(phase: AsyncImagePhase) -> some View {
        if case .success(let image) = phase {
            ImageCache[url] = image
        }

        return content(phase)
    }
}

struct CacheAsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            CacheAsyncImage(
                url: URL(string: "")!
            ) { phase in
                switch phase {
                case .success(let image):
                    image
                @unknown default:
                    fatalError()
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
}


fileprivate class ImageCache {
    static private var cache: [URL: Image] = [:]

    static subscript(url: URL) -> Image? {
        get {
            ImageCache.cache[url]
        }
        set {
            ImageCache.cache[url] = newValue
        }
    }
}

