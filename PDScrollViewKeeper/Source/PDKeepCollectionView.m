//
//  PDKeepCollectionView.m
//  PDScrollViewKeeper
//
//  Created by liang on 2020/2/7.
//  Copyright © 2020 liang. All rights reserved.
//

#import "PDKeepCollectionView.h"

@implementation PDKeepCollectionView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
