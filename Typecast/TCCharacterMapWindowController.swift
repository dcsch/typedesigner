//
//  TCCharacterMapWindowController.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/7/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Cocoa
import os.log

/**
 An editor for the character-to-glyph map, as represented in the CmapTable.
 */
class TCCharacterMapWindowController: NSWindowController, NSCollectionViewDataSource {
  @IBOutlet weak var collectionView: NSCollectionView?
  weak var cmapIndexEntry: TCCmapIndexEntry?
  var characterMappings = [(Int, Int)]()
  var font: TCFont?

  override func windowDidLoad() {
    super.windowDidLoad()

    // Register the collection view item for the character
    let nib = NSNib(nibNamed: "CharacterMapItem", bundle: nil)
    collectionView?.register(nib, forItemWithIdentifier: "charItem")

    if let fontCollection = (document as! TCDocument).fontCollection {

      // TODO: Don't just select the first font
      font = fontCollection.fonts[0]

      characterMappings.removeAll()
      if let format = cmapIndexEntry?.format {
        for range in format.ranges {
          for i in range {
            let mapping = (i, format.glyphCode(characterCode: i))
            characterMappings.append(mapping)
          }
//          os_log("char range: %d...%d", range.lowerBound, range.upperBound)
        }
      }
      collectionView?.reloadData()
    }
  }

  func collectionView(_ collectionView: NSCollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return characterMappings.count
  }

  func collectionView(_ collectionView: NSCollectionView,
                      itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
    let item = collectionView.makeItem(withIdentifier: "charItem", for: indexPath)
    let mapping = characterMappings[indexPath[1]]

    // Character code
    item.textField?.stringValue = String(format: "%04X", mapping.0)

    // Glyph
    if let glyph = font?.glyph(at: mapping.1),
      let head = font?.headTable {
      let size = item.imageView?.bounds.size
      let pixelSize = collectionView.convertToBacking(size!)

      // Scale the glyph down and translate the origin of the bounding box
      let scaleFactor = pixelSize.height / CGFloat(head.yMax - head.yMin)
      var transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
      transform = transform.translatedBy(x: -(CGFloat)(head.xMin),
                                         y: -(CGFloat)(head.yMin))

      // Center the glyph bounding box within the image view
      let imageWidthInUnits = pixelSize.width / scaleFactor
      let tx = (imageWidthInUnits / 2) - (CGFloat(head.xMax - head.xMin) / 2)
      transform = transform.translatedBy(x: tx, y: 0)

      if let cgImage = TCGlyphImageFactory.buildImage(glyph: glyph,
                                                      transform: transform,
                                                      size: pixelSize) {
        let image = NSImage(cgImage: cgImage, size: CGSize.zero)
        item.imageView?.image = image
      }
    } else {
      item.imageView?.image = nil
    }
    return item
  }
}
