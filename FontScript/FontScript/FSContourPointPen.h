//
//  FSContourPointPen.h
//  FontScript
//
//  Created by David Schweinsberg on 7/25/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import "FSPointPen.h"

NS_SWIFT_NAME(ContourPointPen)
@interface FSContourPointPen : NSObject <FSPointPen>

- (nonnull instancetype)initWithGlyph:(nonnull FSGlyph *)glyph NS_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init __attribute__((unavailable));

@end
