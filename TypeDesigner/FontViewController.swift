//
//  FontViewController.swift
//  Type Designer
//
//  Created by David Schweinsberg on 8/29/17.
//  Copyright © 2017 David Schweinsberg. All rights reserved.
//

import Cocoa
import os.log

class FontViewController: NSViewController, NSCollectionViewDataSource,
    NSCollectionViewDelegate, FontControllerConsumer {

  enum GlyphDisplay {
    case glyphOrder
    case adobeGlyphList
    case unicodeBlock
  }

  @IBOutlet weak var collectionView: NSCollectionView!
  @IBOutlet weak var orderPopUpButton: NSPopUpButton!
  @IBOutlet weak var subsetPopUpButton: NSPopUpButton!
  @IBOutlet weak var sizeSlider: NSSlider!
  var characterMappings = [(Int, String?)]()
  var font: UFOFont?
  var ucd = UCD()

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
        display(by: selectedGlyphDisplay)
      } else {
        self.font = nil
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
    if segue.identifier == "ShowGlyph" {
      if let windowController = segue.destinationController as? NSWindowController,
        let viewController = windowController.contentViewController as? GlyphViewController,
        let index = collectionView?.selectionIndexes.first,
        index >= 0 {

        // Set the glyph before connecting with the document, as we're using this information
        // when the document property is set
        if let indexPath = collectionView.selectionIndexPaths.first,
          indexPath.item > -1,
          let glyphs = font?.defaultLayer.glyphs,
          let glyphName = characterMappings[indexPath.item].1,
          let glyph = glyphs[glyphName] as? UFOGlyph {
          viewController.glyph = glyph
        }

        // We're all part of the same document
        if let document = self.view.window?.windowController?.document {
          document.addWindowController(windowController)
        }
      }
    }
  }

  var selectedGlyphDisplay: GlyphDisplay {
    get {
      switch orderPopUpButton.indexOfSelectedItem {
      case 0:
        return .glyphOrder
      case 1:
        return .adobeGlyphList
      case 2:
        return .unicodeBlock
      default:
        return .glyphOrder
      }
    }
  }

  @IBAction func orderPopUpChanged(_ target: Any?) {
    display(by: selectedGlyphDisplay)
  }

  @IBAction func subsetPopUpChanged(_ target: Any?) {
    displayUnicodeBlock(index: subsetPopUpButton.indexOfSelectedItem)
  }

  @IBAction func sizeSliderChanged(_ target: Any?) {
    let size = Double(truncating: pow(2, sizeSlider.integerValue) as NSNumber)
    if let layout = collectionView.collectionViewLayout as? NSCollectionViewFlowLayout {
      layout.itemSize = CGSize(width: size, height: size)
      collectionView.reloadData()
    }
  }

  func displayGlyphOrder() {

    subsetPopUpButton.isHidden = true

    if let font = self.font {
      let glyphOrder = font.libProps.glyphOrder
      characterMappings.removeAll()
      for i in 0..<glyphOrder.count {
        characterMappings.append((i, glyphOrder[i]))
      }
      collectionView.reloadData()
    }
  }

  func displayAdobeGlyphList() {

    subsetPopUpButton.isHidden = true

    let agl = AdobeGlyphListForNewFonts()
    characterMappings.removeAll()
    for entry in agl.entries {
      characterMappings.append((entry.0, entry.1))
    }
    collectionView.reloadData()
  }

  func displayUnicodeBlock() {
    subsetPopUpButton.isHidden = false
    subsetPopUpButton.removeAllItems()
    let blockNames = ucd.blocks.map { $0.name }
    subsetPopUpButton.addItems(withTitles: blockNames)
    displayUnicodeBlock(index: subsetPopUpButton.indexOfSelectedItem)
  }

  func displayUnicodeBlock(index: Int) {
    if let font = self.font {

      // Build a dictionary of unicode scalars and their
      // associated glyph names
      var unicodeToGlyphName: [Unicode.Scalar: String] = [:]
      for glyphEntry in font.defaultLayer.glyphs {
        if let glyph = glyphEntry.value as? UFOGlyph,
          let name = glyphEntry.key as? String {
//          print("\(name), unicode count: \(glyph.unicodes.count)")
          for unicode in glyph.unicodes {
            if let us = Unicode.Scalar(unicode.intValue) {
              unicodeToGlyphName[us] = name
            }
          }
        }
      }

      characterMappings.removeAll()

      let block = ucd.blocks[index]

      for i in block.range {
        if let us = Unicode.Scalar(i),
          let name = unicodeToGlyphName[us] {
          characterMappings.append((i, name))
        } else {
          characterMappings.append((i, nil))
        }
      }
      collectionView.reloadData()
    }
  }

  func display(by: GlyphDisplay) {
    switch by {
    case .glyphOrder:
      displayGlyphOrder()
    case .adobeGlyphList:
      displayAdobeGlyphList()
    case .unicodeBlock:
      displayUnicodeBlock()
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
    if let glyphName = mapping.1 {
      item.textField?.stringValue = glyphName
    } else {
      item.textField?.stringValue = String(format: "%04X", mapping.0)
    }

    // Glyph
    if let glyphs = font?.defaultLayer.glyphs,
      let glyphName = mapping.1,
      let glyph = glyphs[glyphName] as? UFOGlyph {

      let size = item.imageView?.bounds.size
      let pixelSize = collectionView.convertToBacking(size!)

      let bounds = font?.bounds ?? CGRect(x: -512, y: -512, width: 1024, height: 1024)

      // Scale the glyph down and translate the origin of the bounding box
      let scaleFactor = pixelSize.height / bounds.height
      var transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
      transform = transform.translatedBy(x: -bounds.minX,
                                         y: -bounds.minY)

      // Does the thumbnail image fully contain the glyph?
      let imageBounds = CGRect(x: bounds.minX, y: bounds.minY, width: bounds.height, height: bounds.height)
      let glyphBounds = glyph.bounds
      if !imageBounds.contains(glyphBounds) {

        // Shift the glyph to the left of the image bounding box
        let tx = imageBounds.minX - glyphBounds.minX
        transform = transform.translatedBy(x: tx, y: 0)
        os_log("Shifting glyph %@ by %f", glyph.name, tx)
      }

      if let cgImage = GlyphImageFactory.buildImage(glyph: glyph,
                                                    transform: transform,
                                                    size: pixelSize) {
        let image = NSImage(cgImage: cgImage, size: CGSize.zero)
        item.imageView?.image = image
      }
    } else {
      item.imageView?.image = nil
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

    return item
  }

  func collectionView(_ collectionView: NSCollectionView,
                      didSelectItemsAt indexPaths: Set<IndexPath>) {
    if let indexPath = indexPaths.first,
      indexPath.item > -1,
      let glyphName = characterMappings[indexPath.item].1 {
      fontController?.setGlyphName(glyphName)
    }
  }

  func collectionView(_ collectionView: NSCollectionView,
                      didDeselectItemsAt indexPaths: Set<IndexPath>) {
  }

}

extension FontViewController: FontSubscriber {

  func font(_ font: UFOFont, didChangeGlyphName glyphName: String) {
  }

}
