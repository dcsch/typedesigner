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
  var font: UFOFont
  var glyphName: String

  init(font: UFOFont) {
    self.font = font
    self.glyphName = ".notdef"
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

  // MARK: - Actions

  func setGlyphName(_ glyphName: String) {
    self.glyphName = glyphName
    forEachSubscriber { $0.font(font, didChangeGlyphName: glyphName) }
  }
}

protocol FontSubscriber: class {
  func font(_ font: UFOFont, didChangeGlyphName glyphName: String)
}

// Any given view controller can implement the FontControllerConsumer to get assigned the current FontController
protocol FontControllerConsumer {
  var fontController: FontController? { get set }
}
