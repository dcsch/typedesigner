//
//  CharacterMapViewController.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/29/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Cocoa
import os.log

class CharacterMapViewController: NSViewController, NSCollectionViewDataSource,
    NSCollectionViewDelegate, FontControllerConsumer {
  @IBOutlet weak var collectionView: NSCollectionView?
//  weak var cmapIndexEntry: TCCmapIndexEntry?
  var characterMappings = [(Int, Int)]()
  var font: UFOFont?

  var fontController: FontController? {
    didSet {
      if let old = oldValue {
        old.removeSubscriber(self)
      }
      if let new = fontController {
        new.addSubscriber(self)
      }
      if let font = fontController?.font {
        self.font = font

        // TODO: The cmap should be selectable
//        cmapIndexEntry = font.cmapTable.entries.first
//        let mapping = font.cmapTable.mappings[0]

//        characterMappings.removeAll()
//        if let format = cmapIndexEntry?.format {
//          for range in format.ranges {
//            for i in range {
//              let mapping = (i, format.glyphCode(characterCode: i))
//              characterMappings.append(mapping)
//            }
//          }
//        }
//        let charCodes = mapping.glyphCodes.keys.sorted()
//        for charCode in charCodes {
//          if let glyphCode = mapping.glyphCodes[charCode] {
//            characterMappings.append((charCode, glyphCode))
//          }
//        }

        // No mapping - just the glyph order
        let glyphOrder = font.libProps.glyphOrder
        characterMappings.removeAll()
        for i in 0..<glyphOrder.count {
          characterMappings.append((i, i))
        }
        collectionView?.reloadData()
      } else {
        self.font = nil
//        cmapIndexEntry = nil
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewDidAppear() {
//    if let fontCollection = document?.fontCollection,
//      fontCollection.fonts.count > 1 {
//      performSegue(withIdentifier: "ImportFont", sender: self)
//    }
  }

  override var representedObject: Any? {
    didSet {
    }
  }

  override func shouldPerformSegue(withIdentifier identifier: NSStoryboardSegue.Identifier, sender: Any?) -> Bool {

    // Look through the existing window controllers. If this glyph is already
    // displayed, we want to show that window
//    for windowController in (document?.windowControllers)! {
//      if identifier == "ShowGlyph",
//        let viewController = windowController.contentViewController as? GlyphViewController,
//        let glyphIndex = viewController.glyphView?.glyph?.glyphIndex,
//        let selectionIndex = collectionView?.selectionIndexes.first,
//        selectionIndex >= 0,
//        glyphIndex == characterMappings[selectionIndex].1 {
//        windowController.showWindow(self)
//        return false
//      }
//    }
    return super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
  }

  override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
    if segue.identifier?.rawValue == "ShowGlyph" {
      if let windowController = segue.destinationController as? NSWindowController,
        let viewController = windowController.contentViewController as? GlyphViewController,
        let index = collectionView?.selectionIndexes.first,
        index >= 0 {

//        // We're all part of the same document
//        document?.addWindowController(windowController)
//
//        let glyph = font?.glyph(at: characterMappings[index].1)
//        viewController.glyphReference = (font, glyph)
      }
    }
  }

  func collectionView(_ collectionView: NSCollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return characterMappings.count
  }

  func collectionView(_ collectionView: NSCollectionView,
                      itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
    let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CharacterMapItem"), for: indexPath)
    let mapping = characterMappings[indexPath.item]

    if let characterMapItem = item as? CharacterMapItem {
      characterMapItem.characterMapViewController = self
    }

    // Character code
    item.textField?.stringValue = String(format: "%04X", mapping.0)

    // Glyph
    if let glyphs = font?.defaultLayer.glyphs,
      let glyphOrder = font?.libProps.glyphOrder {
      let glyphIndex = characterMappings[indexPath.item].1
      let glyphName = glyphOrder[glyphIndex]
      let glyph = glyphs[glyphName] as! UFOGlyph
      let size = item.imageView?.bounds.size
      let pixelSize = collectionView.convertToBacking(size!)

      let bounds = font?.bounds ?? CGRect(x: -512, y: -512, width: 1024, height: 1024)

      // Scale the glyph down and translate the origin of the bounding box
      let scaleFactor = pixelSize.height / bounds.height
      var transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
      transform = transform.translatedBy(x: -bounds.minX,
                                         y: -bounds.minY)

      // Center the glyph bounding box within the image view
      let imageWidthInUnits = pixelSize.width / scaleFactor
      let tx = (imageWidthInUnits / 2) - (bounds.width / 2)
      transform = transform.translatedBy(x: tx, y: 0)

      if let cgImage = GlyphImageFactory.buildImage(glyph: glyph,
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
    if let indexPath = indexPaths.first,
      indexPath.item > -1,
      let font = self.font {
      let glyphOrder = font.libProps.glyphOrder
      let glyphIndex = characterMappings[indexPath.item].1
      fontController?.setGlyphName(glyphOrder[glyphIndex])
    }
  }
  
  func collectionView(_ collectionView: NSCollectionView,
                      didDeselectItemsAt indexPaths: Set<IndexPath>) {
  }
}

extension CharacterMapViewController: FontSubscriber {

  func font(_ font: UFOFont, didChangeGlyphName glyphName: String) {
  }
}
