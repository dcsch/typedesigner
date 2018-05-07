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
  var font: Font?

  var fontController: FontController? {
    didSet {
      if let old = oldValue { old.removeSubscriber(self) }
      if let new = fontController { new.addSubscriber(self) }
      if let font = fontController?.font {
        self.font = font

        // TODO: The cmap should be selectable
//        cmapIndexEntry = font.cmapTable.entries.first
        let mapping = font.cmapTable.mappings[0]

        characterMappings.removeAll()
//        if let format = cmapIndexEntry?.format {
//          for range in format.ranges {
//            for i in range {
//              let mapping = (i, format.glyphCode(characterCode: i))
//              characterMappings.append(mapping)
//            }
//          }
//        }
        let charCodes = mapping.glyphCodes.keys.sorted()
        for charCode in charCodes {
          if let glyphCode = mapping.glyphCodes[charCode] {
            characterMappings.append((charCode, glyphCode))
          }
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
    if let ttFont = font as? TTFont {
      let descript = ttFont.glyfTable.descript[mapping.1]
      let head = ttFont.headTable
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

      var cgImage: CGImage?
      if let simpleDescript = descript as? GlyfSimpleDescript {
        cgImage = GlyphImageFactory.buildImage(glyph: simpleDescript,
                                               transform: transform,
                                               size: pixelSize)
      } else if let compositeDescript = descript as? GlyfCompositeDescript {
        cgImage = GlyphImageFactory.buildImage(glyph: compositeDescript,
                                               font: ttFont,
                                               transform: transform,
                                               size: pixelSize)
      }
      if cgImage != nil {
        let image = NSImage(cgImage: cgImage!, size: CGSize.zero)
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
    if let indexPath = indexPaths.first,
      indexPath.item > -1 {
      let glyphIndex = characterMappings[indexPath.item].1
      fontController?.setGlyphIndex(glyphIndex)
    }
  }
  
  func collectionView(_ collectionView: NSCollectionView,
                      didDeselectItemsAt indexPaths: Set<IndexPath>) {
    os_log("Deselected: %@", indexPaths)
  }
}

extension CharacterMapViewController: FontSubscriber {
  func font(_ font: Font, didChangeGlyphIndex glyphIndex: Int) {
    os_log("CharacterMapViewController.font:didChangeGlyphIndex:")
  }
}