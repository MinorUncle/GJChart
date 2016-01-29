//
//  ChartViewController.h
//  TVBAINIAN
//
//  Created by tongguan on 16/1/21.
//  Copyright © 2016年 tongguantech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationFuncationViewContoller.h"
#import "CoordinateView.h"

@interface ChartViewController : NavigationFuncationViewContoller
@property(nonatomic,assign)int64_t deviceId;
@property(nonatomic,assign)int cid;

@end
