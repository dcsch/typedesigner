//
//  FontController.swift
//  Type Designer
//
//  Created by David Schweinsberg on 9/3/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Foundation

class FontController {
  private let subscribers = NSHashTable<AnyObject>.weakObjects()
  var font: Font
  var glyphIndex: Int

  init(font: Font) {
    self.font = font
    self.glyphIndex = 0
  }

  // MARK: - Subscription

  func addSubscriber(_ subscriber: FontSubscriber) {
    subscribers.add(subscriber)
  }

  func removeSubscriber(_ subscriber: FontSubscriber) {
    subscribers.remove(subscriber)
  }

  private func forEachSubscriber(_ work: (FontSubscriber) -> Void) {
    for object in subscribers.objectEnumerator() {
      guard let subscriber = object as? FontSubscriber else { continue }
      work(subscriber)
    }
  }

  // Mark: - Actions

  func setGlyphIndex(_ glyphIndex: Int) {
    self.glyphIndex = glyphIndex
    forEachSubscriber { $0.font(font, didChangeGlyphIndex: glyphIndex) }
  }
}

protocol FontSubscriber: class {
  func font(_ font: Font, didChangeGlyphIndex glyphIndex: Int)
}

// Any given view controller can implement the FontControllerConsumer to get assigned the current FontController
protocol FontControllerConsumer {
  var fontController: FontController? { get set }
}
