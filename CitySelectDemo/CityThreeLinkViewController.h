//
//  CityThreeLinkViewController.h
//  Intelligent_Fire
//
//  Created by 高磊 on 2016/11/10.
//  Copyright © 2016年 高磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CityThreeLinkDelegate <NSObject>


/**
 最终选中的城市信息

 @param name 选中的城市名字
 @param areaId 对应的id
 */
- (void)selectWithAreaName:(NSString *)name areaId:(NSString *)areaId;

@end

@interface CityThreeLinkCell :UITableViewCell

//是否显示选中图标 
@property (nonatomic,assign) BOOL showSelectIcon;

@property (nonatomic,strong) UILabel *titleLable;//标题
@property (nonatomic,copy) NSString *areaId;
@end


@interface CityThreeLinkViewController : UIViewController

@property (nonatomic,weak) id <CityThreeLinkDelegate>delegate;

@end
