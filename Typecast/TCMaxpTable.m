//
//  TCMaxpTable.m
//  Typecast
//
//  Created by David Schweinsberg on 3/12/12.
//  Copyright (c) 2012 David Schweinsberg. All rights reserved.
//

#import "TCMaxpTable.h"
#import "TCDirectoryEntry.h"
#import "TCDataInput.h"

@implementation TCMaxpTable

- (id)initWithDataInput:(TCDataInput *)dataInput directoryEntry:(TCDirectoryEntry *)entry
{
    self = [super init];
    if (self)
    {
        self.directoryEntry = [entry copy];
        _versionNumber = [dataInput readInt];

        // CFF fonts use version 0.5, TrueType fonts use version 1.0
        if (_versionNumber == 0x00005000)
        {
            _numGlyphs = [dataInput readUnsignedShort];
        }
        else if (_versionNumber == 0x00010000)
        {
            _numGlyphs = [dataInput readUnsignedShort];
            _maxPoints = [dataInput readUnsignedShort];
            _maxContours = [dataInput readUnsignedShort];
            _maxCompositePoints = [dataInput readUnsignedShort];
            _maxCompositeContours = [dataInput readUnsignedShort];
            _maxZones = [dataInput readUnsignedShort];
            _maxTwilightPoints = [dataInput readUnsignedShort];
            _maxStorage = [dataInput readUnsignedShort];
            _maxFunctionDefs = [dataInput readUnsignedShort];
            _maxInstructionDefs = [dataInput readUnsignedShort];
            _maxStackElements = [dataInput readUnsignedShort];
            _maxSizeOfInstructions = [dataInput readUnsignedShort];
            _maxComponentElements = [dataInput readUnsignedShort];
            _maxComponentDepth = [dataInput readUnsignedShort];
        }
    }
    return self;
}

- (NSString *)description
{
    NSString *str = [NSString stringWithFormat:
                     @"'maxp' Table - Maximum Profile\n------------------------------"
                     @"\n        'maxp' version:         %x"
                     @"\n        numGlyphs:              %d",
                     _versionNumber,
                     _numGlyphs];

    if (_versionNumber == 0x00010000)
        str = [str stringByAppendingFormat:
               @"\n        maxPoints:              %d" //).append(maxPoints)
               @"\n        maxContours:            %d" //).append(maxContours)
               @"\n        maxCompositePoints:     %d" //).append(maxCompositePoints)
               @"\n        maxCompositeContours:   %d" //).append(maxCompositeContours)
               @"\n        maxZones:               %d" //).append(maxZones)
               @"\n        maxTwilightPoints:      %d" //).append(maxTwilightPoints)
               @"\n        maxStorage:             %d" //).append(maxStorage)
               @"\n        maxFunctionDefs:        %d" //).append(maxFunctionDefs)
               @"\n        maxInstructionDefs:     %d" //).append(maxInstructionDefs)
               @"\n        maxStackElements:       %d" //).append(maxStackElements)
               @"\n        maxSizeOfInstructions:  %d" //).append(maxSizeOfInstructions)
               @"\n        maxComponentElements:   %d" //).append(maxComponentElements)
               @"\n        maxComponentDepth:      %d",//).append(maxComponentDepth);
               _maxPoints,
               _maxContours,
               _maxCompositePoints,
               _maxCompositeContours,
               _maxZones,
               _maxTwilightPoints,
               _maxStorage,
               _maxFunctionDefs,
               _maxInstructionDefs,
               _maxStackElements,
               _maxSizeOfInstructions,
               _maxComponentElements,
               _maxComponentDepth];
    else
        str = [str stringByAppendingString:@"\n"];
    return str;
}

@end
