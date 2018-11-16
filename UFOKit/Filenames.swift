//
//  Filenames.swift
//  UFOKit
//
//  Created by David Schweinsberg on 10/23/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

import Foundation

public class Filenames {
  static let illegalCharacters = Filenames.illegalUFOFilenameCharacters
  static let reservedFilenames = Filenames.reservedUFOFilenames

  public class func filename(glyphName: String, suffix: String? = nil) -> String {

    let maxFileNameLength = 255

    // Replace any initial period with an underscore
    var name = glyphName
    if name.hasPrefix(".") {
      name = "_" + name.suffix(from: String.Index(encodedOffset: 1))
    }

    // Replace illegal characters with an underscore and append an uppercase
    // character with an underscore
    var filteredName = ""
    for character in name {
      for scalar in character.unicodeScalars {
        if illegalCharacters.contains(scalar) {
          filteredName.append("_")
        } else {
          filteredName.append(Character(scalar))
        }
        if CharacterSet.uppercaseLetters.contains(scalar) {
          filteredName.append("_")
        }
      }
    }
    name = filteredName

    // Max 255 characters
    let maxNameLength = maxFileNameLength - (suffix?.count ?? 0)
    if name.count > maxNameLength {
      var endIndex = name.endIndex
      name.formIndex(&endIndex, offsetBy: maxNameLength - name.count)
      name = String(name[..<endIndex])
    }

    // Prepend any reserved filenames with an underscore
    var parts = [String]()
    for part in name.split(separator: ".") {
      if reservedFilenames.contains(part.uppercased()) {
        parts.append("_" + String(part))
      } else {
        parts.append(String(part))
      }
    }
    name = ""
    for part in parts {
      if name.count > 0 {
        name += "."
      }
      name += part
    }

    if let suffix = suffix {
      name += suffix
    }

    // TODO: Test for clash

    return name
  }

}

extension Filenames {
  static var illegalUFOFilenameCharacters: CharacterSet {
    get {
      var charSet = CharacterSet(charactersIn: Unicode.Scalar(0)...Unicode.Scalar(32))
      charSet.insert(Unicode.Scalar(0x7f))
      charSet.insert(charactersIn: "\"*+/:<>?[\\]|")
      return charSet
    }
  }
}

extension Filenames {
  static var reservedUFOFilenames: [String] {
    get {
      // Rules from UFO spec + https://docs.microsoft.com/en-us/windows/desktop/fileio/naming-a-file
      // Note that UFO convention explicitly reserves "A:-Z:" even though
      // this name can never be formed since it contains a colon
      var filenames = ["CON", "PRN", "AUX", "NUL", "CLOCK$"]
      for i in 1...9 {
        filenames.append("COM\(i)")
        filenames.append("LPT\(i)")
      }
      return filenames
    }
  }
}
