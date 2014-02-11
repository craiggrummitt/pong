#import "TFPaddle.h"

@implementation TFPaddle

- (void)layoutSubviews {
    // Make each paddle have rounded corners
    self.layer.cornerRadius = CGRectGetHeight(self.frame)/2;
}

- (UIDynamicItemBehavior *)dynamicBehavior {
    if (!_dynamicBehavior) {
        _dynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self]];
    }

    _dynamicBehavior.density = 1000.0f;
    _dynamicBehavior.allowsRotation = false;
    return _dynamicBehavior;
}

@end
