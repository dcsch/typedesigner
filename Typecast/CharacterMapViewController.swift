//
//  CharacterMapViewController.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/29/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Cocoa
import os.log

class CharacterMapViewController: NSViewController,
    NSCollectionViewDataSource, NSCollectionViewDelegate {
  @IBOutlet weak var collectionView: NSCollectionView?
  weak var cmapIndexEntry: TCCmapIndexEntry?
  var characterMappings = [(Int, Int)]()
  var font: TCFont?

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override var representedObject: Any? {
    didSet {
    }
  }

  weak var document: TCDocument? {
    didSet {
      if let fontCollection = document?.fontCollection {

        // Should we close the document on closing this view?
        if fontCollection.fonts.count == 1 {
          self.view.window?.windowController?.shouldCloseDocument = true
        }

        // TODO: Don't just select the first font
        font = fontCollection.fonts[0]

        // TODO: The cmap should be selectable
        cmapIndexEntry = font?.cmapTable.entries.first

        characterMappings.removeAll()
        if let format = cmapIndexEntry?.format {
          for range in format.ranges {
            for i in range {
              let mapping = (i, format.glyphCode(characterCode: i))
              characterMappings.append(mapping)
            }
          }
        }
        collectionView?.reloadData()
      }
    }
  }

  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {

    // Look through the existing window controllers. If this glyph is already
    // displayed, we want to show that window
    for windowController in (document?.windowControllers)! {
      if identifier == "ShowGlyph",
        let viewController = windowController.contentViewController as? GlyphViewController,
        let glyphIndex = viewController.glyphView?.glyph?.glyphIndex,
        let selectionIndex = collectionView?.selectionIndexes.first,
        selectionIndex >= 0,
        glyphIndex == characterMappings[selectionIndex].1 {
        windowController.showWindow(self)
        return false
      }
    }
    return super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
  }

  override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
    if segue.identifier == "ShowGlyph" {
      if let windowController = segue.destinationController as? NSWindowController,
        let viewController = windowController.contentViewController as? GlyphViewController,
        let index = collectionView?.selectionIndexes.first,
        index >= 0 {

        // We're all part of the same document
        document?.addWindowController(windowController)

        let glyph = font?.glyph(at: characterMappings[index].1)
        viewController.glyphReference = (font, glyph)
      }
    }
  }

  func collectionView(_ collectionView: NSCollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return characterMappings.count
  }

  func collectionView(_ collectionView: NSCollectionView,
                      itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
    let item = collectionView.makeItem(withIdentifier: "CharacterMapItem", for: indexPath)
    let mapping = characterMappings[indexPath.item]

    if let characterMapItem = item as? CharacterMapItem {
      characterMapItem.characterMapViewController = self
    }

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

//      // Are we selected?
//      if item.isSelected {
//        os_log("selected")
//      } else {
//      }

//      switch item.highlightState {
//      case .none: break
//        item.view.layer?.backgroundColor = CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//      case .forSelection:
//        item.view.layer?.backgroundColor = CGColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
//      case .forDeselection: break
//        item.view.layer?.backgroundColor = CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//      case .asDropTarget: break
//        item.view.layer?.backgroundColor = CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//      }
    } else {
      item.imageView?.image = nil
    }
    return item
  }

  func collectionView(_ collectionView: NSCollectionView,
                      didSelectItemsAt indexPaths: Set<IndexPath>) {
    os_log("Selected: %@", indexPaths)
  }
  
  func collectionView(_ collectionView: NSCollectionView,
                      didDeselectItemsAt indexPaths: Set<IndexPath>) {
    os_log("Deselected: %@", indexPaths)
  }
}
