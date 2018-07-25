//
//  FSBoundsPen.h
//  FontScript
//
//  Created by David Schweinsberg on 6/8/18.
//  Copyright © 2018 David Schweinsberg. All rights reserved.
//

#import "FSPen.h"

NS_SWIFT_NAME(BoundsPen)
@interface FSBoundsPen : NSObject <FSPen>

@property CGRect bounds;

@end
