//
//  PDScrollViewKeeper.h
//  PDScrollViewKeeper
//
//  Created by liang on 2020/2/7.
//  Copyright © 2020 liang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDKeepScrollView.h"
#import "PDKeepTableView.h"
#import "PDKeepCollectionView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PDScrollViewKeeperDelegate <NSObject>

- (CGFloat)thresholdContentOffsetYForSuperScrollView:(UIScrollView *)scrollView;

@end

@interface PDScrollViewKeeper : NSObject

+ (PDScrollViewKeeper *)keeperWithIdentifier:(NSString *)identifier;
+ (void)firedKeeperWithIdentifier:(NSString *)identifier;

@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, weak) id<PDScrollViewKeeperDelegate> delegate;

- (void)setSelectedIndex:(NSInteger)selectedIndex;

- (void)attachSuperView:(UIScrollView *)scrollView;
- (void)attachChildScrollView:(UIScrollView *)scrollView atIndex:(NSInteger)index;

- (void)superScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)childScrollViewDidScroll:(UIScrollView *)scrollView;

- (void)takeOverScrollIndicator;

@end

NS_ASSUME_NONNULL_END
