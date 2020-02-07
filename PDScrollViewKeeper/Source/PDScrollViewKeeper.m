//
//  PDScrollViewKeeper.m
//  PDScrollViewKeeper
//
//  Created by liang on 2020/2/7.
//  Copyright © 2020 liang. All rights reserved.
//

#import "PDScrollViewKeeper.h"

@interface PDScrollViewKeeper () {
    BOOL _takeOverScrollIndicator;
}

@property (class, strong, readonly) NSMutableDictionary<NSString *, PDScrollViewKeeper *> *keepers;
@property (nonatomic, strong) UIScrollView *superScrollView;
@property (nonatomic, strong) NSMapTable<NSNumber *, UIScrollView *> *childScrollViews;
@property (nonatomic, assign) BOOL superScrollViewScrollEnable;
@property (nonatomic, assign) BOOL childScrollViewScrollEnable;
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation PDScrollViewKeeper

+ (NSMutableDictionary<NSString *,PDScrollViewKeeper *> *)keepers {
    static NSMutableDictionary *_keepers;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _keepers = [NSMutableDictionary dictionary];
    });
    return _keepers;
}

+ (PDScrollViewKeeper *)keeperWithIdentifier:(NSString *)identifier {
    NSAssert(identifier.length, @"The argument `identifier` is invalid!");
    PDScrollViewKeeper *keeper = self.keepers[identifier];
    if (keeper) { return keeper; }
    
    keeper = [[PDScrollViewKeeper alloc] initWithIdentifier:identifier];
    self.keepers[identifier] = keeper;
    return keeper;
}

+ (void)firedKeeperWithIdentifier:(NSString *)identifier {
    NSAssert(identifier.length, @"The argument `identifier` is invalid!");
    self.keepers[identifier] = nil;
}

- (instancetype)initWithIdentifier:(NSString *)identifier {
    self = [super init];
    if (self) {
        _identifier = [identifier copy];
    }
    return self;
}

- (void)attachSuperView:(UIScrollView *)scrollView {
    self.superScrollView = scrollView;
}

- (void)attachChildScrollView:(UIScrollView *)scrollView atIndex:(NSInteger)index {
    [self.childScrollViews setObject:scrollView forKey:@(index)];
}

- (void)superScrollViewDidScroll:(UIScrollView *)scrollView {
    UIScrollView *superScrollView = self.superScrollView;
    UIScrollView *childScrollView = [self.childScrollViews objectForKey:@(self.selectedIndex)];
    if (!superScrollView || !childScrollView) { return; }

    CGFloat threshold = [self.delegate thresholdContentOffsetYForSuperScrollView:superScrollView];

    if (superScrollView.contentOffset.y >= threshold) { // Arrive top
        superScrollView.contentOffset = CGPointMake(0.f, threshold);
        
        if (self.superScrollViewScrollEnable) {
            self.superScrollViewScrollEnable = NO;
            self.childScrollViewScrollEnable = YES;
        }
    } else {
        if (!self.superScrollViewScrollEnable) {
            superScrollView.contentOffset = CGPointMake(0.f, threshold);
        }
    }
    
    if (_takeOverScrollIndicator) {
        superScrollView.showsVerticalScrollIndicator = self.superScrollViewScrollEnable ? YES : NO;
    }
}

- (void)childScrollViewDidScroll:(UIScrollView *)scrollView {
    UIScrollView *superScrollView = self.superScrollView;
    UIScrollView *childScrollView = [self.childScrollViews objectForKey:@(self.selectedIndex)];
    if (!superScrollView || !childScrollView) { return; }

    if (!self.childScrollViewScrollEnable) {
        childScrollView.contentOffset = CGPointZero;
    }
    
    if (childScrollView.contentOffset.y <= 0.f) {
        self.childScrollViewScrollEnable = NO;
        self.superScrollViewScrollEnable = YES;
        childScrollView.contentOffset = CGPointZero;
    }
    
    if (_takeOverScrollIndicator) {
        childScrollView.showsVerticalScrollIndicator = self.childScrollViewScrollEnable ? YES : NO;
    }
}

- (void)takeOverScrollIndicator {
    _takeOverScrollIndicator = YES;
}

#pragma mark - Setter Methods
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    
    CGFloat threshold = [self.delegate thresholdContentOffsetYForSuperScrollView:self.superScrollView];
    self.childScrollViewScrollEnable = (self.superScrollView.contentOffset.y >= threshold);
    self.superScrollViewScrollEnable = !self.childScrollViewScrollEnable;
}

#pragma mark - Getter Methods
- (NSMapTable<NSNumber *,UIScrollView *> *)childScrollViews {
    if (!_childScrollViews) {
        _childScrollViews = [NSMapTable strongToWeakObjectsMapTable];
    }
    return _childScrollViews;
}

@end
