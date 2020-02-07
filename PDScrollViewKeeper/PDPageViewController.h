//
//  PDPageViewController.h
//  PDScrollViewRepairer
//
//  Created by liang on 2020/2/7.
//  Copyright © 2020 liang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PDPageViewControllerDelegate <NSObject>

- (CGFloat)containerViewHeight;

@end

@interface PDPageViewController : UIViewController

@property (nonatomic, weak) id<PDPageViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
