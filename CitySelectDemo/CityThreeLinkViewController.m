//
//  CityThreeLinkViewController.m
//  Intelligent_Fire
//
//  Created by 高磊 on 2016/11/10.
//  Copyright © 2016年 高磊. All rights reserved.
//

#import "CityThreeLinkViewController.h"
#import "CityModel.h"
#import "ProvinceModel.h"
#import "DistrictModel.h"

#define UICOLOR_FROM_RGB_OxFF(rgbValue)     [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface CityThreeLinkCell ()

@property (nonatomic,strong) UIImageView *selectImageView;//选中图标

@end

@implementation CityThreeLinkCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.showSelectIcon = NO;
        
        [self.contentView addSubview:self.titleLable];
        [self.contentView addSubview:self.selectImageView];
        
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width/3.0;
        
        [self.titleLable setFrame:CGRectMake(10, 0, width - 23, CGRectGetHeight(self.contentView.frame))];
        [self.selectImageView setFrame:CGRectMake(CGRectGetMaxX(self.titleLable.frame), (CGRectGetHeight(self.contentView.frame)-10)/2.0, 13, 10)];
    }
    return self;
}


#pragma mark == 懒加载
- (UILabel *)titleLable
{
    if (nil == _titleLable)
    {
        _titleLable = [[UILabel alloc] init];
        _titleLable.textColor = UICOLOR_FROM_RGB_OxFF(0x666666);
        _titleLable.font = [UIFont systemFontOfSize:14];
    }
    return _titleLable;
}

- (UIImageView *)selectImageView
{
    if (nil == _selectImageView)
    {
        _selectImageView = [[UIImageView alloc] init];
        _selectImageView.image = [UIImage imageNamed:@"选中"];
        _selectImageView.hidden = YES;
    }
    return _selectImageView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected)
    {
        self.titleLable.textColor = UICOLOR_FROM_RGB_OxFF(0xFF6c21);
        
        if (self.showSelectIcon)
        {
            self.selectImageView.hidden = NO;
        }
        else
        {
            self.selectImageView.hidden = YES;
        }
    }
    else
    {
        self.titleLable.textColor = UICOLOR_FROM_RGB_OxFF(0x666666);
    
        self.selectImageView.hidden = YES;
    }
}

@end


@interface CityThreeLinkViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *leftTableView;//显示省
@property (nonatomic,strong) UITableView *middleTableView;//显示市
@property (nonatomic,strong) UITableView *rightTableView;//显示区县

//分别代表两条分割线
@property (nonatomic,strong) UIView *lineA;
@property (nonatomic,strong) UIView *lineB;

//各自的数据源
@property (nonatomic,strong) NSMutableArray *leftDatas;
@property (nonatomic,strong) NSMutableArray *middleDatas;
@property (nonatomic,strong) NSMutableArray *rightDatas;

//选中的不同地方
@property (nonatomic,strong) NSIndexPath *leftIndexPath;
@property (nonatomic,strong) NSIndexPath *middleIndexPath;
@property (nonatomic,strong) NSIndexPath *rightIndexPath;

//被选中的区域
@property (nonatomic,copy) NSString *selectName;
//被选中的id
@property (nonatomic,copy) NSString *selectId;
@end

@implementation CityThreeLinkViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        //默认数据加载 分别取第一个数据
        
        self.leftDatas = [ProvinceModel provinceModels];
        
        ProvinceModel *provinceModel = self.leftDatas[0];
        [self.middleDatas addObjectsFromArray:provinceModel.data];
        
        CityModel *cityModel = self.middleDatas[0];
        
        [self.rightDatas addObjectsFromArray:cityModel.data];
        
        //默认选中第一行
        self.leftIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        self.middleIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        self.rightIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        //默认的选择值
        if (self.rightDatas.count > 0)
        {
            DistrictModel *districtModel = self.rightDatas[0];
            self.selectName = districtModel.name;
            self.selectId = districtModel.s_id;
        }
        else
        {
            self.selectName = cityModel.name;
            self.selectId = cityModel.s_id;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UICOLOR_FROM_RGB_OxFF(0xeeeeee);
    
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.middleTableView];
    [self.view addSubview:self.rightTableView];

    [self.view addSubview:self.lineA];
    [self.view addSubview:self.lineB];
    
    [self makeViewConstraints];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectWithAreaName:areaId:)])
    {
        [self.delegate selectWithAreaName:self.selectName areaId:self.selectId];
    }
}

//布局
- (void)makeViewConstraints
{
    CGFloat width = self.view.frame.size.width/3.0;
    CGFloat height = self.view.frame.size.height-20;
    
    [self.leftTableView setFrame:CGRectMake(0, 20, width, height)];
    [self.middleTableView setFrame:CGRectMake(CGRectGetMaxX(self.leftTableView.frame), 20, width, height)];
    [self.rightTableView setFrame:CGRectMake(CGRectGetMaxX(self.middleTableView.frame), 20, width, height)];
    
    [self.lineA setFrame:CGRectMake(CGRectGetMaxX(self.leftTableView.frame), 20, 1, height)];
    [self.lineB setFrame:CGRectMake(CGRectGetMaxX(self.middleTableView.frame), 20, 1, height)];

}

#pragma mark == UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.leftTableView)
    {
        return self.leftDatas.count;
    }
    else if (tableView == self.middleTableView)
    {
        return self.middleDatas.count;
    }
    else
    {
        return self.rightDatas.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTableView)
    {
        static NSString *const iDentifirtStringleft = @"cityleftcell";
        
        CityThreeLinkCell *cell = [tableView dequeueReusableCellWithIdentifier:iDentifirtStringleft];
        if (!cell)
        {
            cell = [[CityThreeLinkCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iDentifirtStringleft];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        ProvinceModel *pro = self.leftDatas[indexPath.row];
        
        cell.titleLable.text = pro.name;
        cell.areaId = pro.s_id;
        
        //默认选中第一行
        if (self.leftIndexPath)
        {
            if (indexPath.row == self.leftIndexPath.row)
            {
                [self.leftTableView selectRowAtIndexPath:self.leftIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            }
        }
        return cell;
    }
    else if (tableView == self.middleTableView)
    {
        static NSString *const iDentifirtStringmiddle = @"citymiddlecell";
        
        CityThreeLinkCell *cell = [tableView dequeueReusableCellWithIdentifier:iDentifirtStringmiddle];
        if (!cell)
        {
            cell = [[CityThreeLinkCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iDentifirtStringmiddle];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        CityModel *pro = self.middleDatas[indexPath.row];
        
        cell.titleLable.text = pro.name;
        cell.areaId = pro.s_id;

        if (self.middleIndexPath)
        {
            if (indexPath.row == self.middleIndexPath.row)
            {
                [self.middleTableView selectRowAtIndexPath:self.middleIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            }
        }

        return cell;
    }
    else
    {
        static NSString *const iDentifirtStringright = @"cityrightcell";
        
        CityThreeLinkCell *cell = [tableView dequeueReusableCellWithIdentifier:iDentifirtStringright];
        if (!cell)
        {
            cell = [[CityThreeLinkCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iDentifirtStringright];
            cell.showSelectIcon = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        DistrictModel *pro = self.rightDatas[indexPath.row];
        
        cell.titleLable.text = pro.name;
        cell.areaId = pro.s_id;
        
        if (self.rightIndexPath)
        {
            if (indexPath.row == self.rightIndexPath.row)
            {
                [self.rightTableView selectRowAtIndexPath:self.rightIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            }
        }
        
        return cell;
    }
}

#pragma mark == UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTableView)
    {
        if (indexPath == self.leftIndexPath) {
            return;
        }
        
        //将之前的选中cell状态改为未选中状态
        if (self.leftIndexPath)
        {
            CityThreeLinkCell *cell = [tableView cellForRowAtIndexPath:self.leftIndexPath];
            [cell setSelected:NO animated:YES];
        }
        CityThreeLinkCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setSelected:YES animated:YES];
        
        self.leftIndexPath = indexPath;
        
        ProvinceModel *provinceModel = self.leftDatas[indexPath.row];
        
        [self.middleDatas removeAllObjects];
        
        [self.middleDatas addObjectsFromArray:provinceModel.data];
        

        if (self.middleDatas.count > 0)
        {
            self.middleIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            
            CityModel *cityModel = self.middleDatas[0];
            
            [self.rightDatas removeAllObjects];
            
            [self.rightDatas addObjectsFromArray:cityModel.data];
            
            if (self.rightDatas.count > 0)
            {
                self.rightIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                
                DistrictModel *districtModel = self.rightDatas[0];
                self.selectName = districtModel.name;
                self.selectId = districtModel.s_id;
            }
            else
            {
                self.selectName = cityModel.name;
                self.selectId = cityModel.s_id;
            }
        }
        
        [self.middleTableView reloadData];
        
        [self.rightTableView reloadData];
    }
    else if (tableView == self.middleTableView)
    {
        if (indexPath == self.middleIndexPath) {
            return;
        }
        if (self.middleIndexPath)
        {
            CityThreeLinkCell *cell = [tableView cellForRowAtIndexPath:self.middleIndexPath];
            [cell setSelected:NO animated:YES];
        }
        
        CityThreeLinkCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setSelected:YES animated:YES];
        
        self.middleIndexPath = indexPath;
        
        
        CityModel *cityModel = self.middleDatas[indexPath.row];
        
        [self.rightDatas removeAllObjects];
        
        [self.rightDatas addObjectsFromArray:cityModel.data];

        if (self.rightDatas.count > 0)
        {
            self.rightIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            
            DistrictModel *districtModel = self.rightDatas[0];
            self.selectName = districtModel.name;
            self.selectId = districtModel.s_id;
        }
        else
        {
            self.selectName = cityModel.name;
            self.selectId = cityModel.s_id;
        }
        
        [self.rightTableView reloadData];
    }
    else
    {
        if (indexPath == self.rightIndexPath) {
            return;
        }
        
        if (self.rightIndexPath)
        {
            CityThreeLinkCell *cell = [tableView cellForRowAtIndexPath:self.rightIndexPath];
            [cell setSelected:NO animated:YES];
        }
        CityThreeLinkCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setSelected:YES animated:YES];
        
        self.rightIndexPath = indexPath;
        
        self.selectName = cell.titleLable.text;
        self.selectId = cell.areaId;
    }
}


#pragma mark == private method
- (void)backAboveVc
{
//    [self popController];
}


#pragma mark == 懒加载
- (NSMutableArray *)leftDatas
{
    if (nil == _leftDatas)
    {
        _leftDatas = [[NSMutableArray alloc] init];
    }
    return _leftDatas;
}

- (NSMutableArray *)middleDatas
{
    if (nil == _middleDatas)
    {
        _middleDatas = [[NSMutableArray alloc] init];
    }
    return _middleDatas;
}


- (NSMutableArray *)rightDatas
{
    if (nil == _rightDatas)
    {
        _rightDatas = [[NSMutableArray alloc] init];
    }
    return _rightDatas;
}

- (UIView *)lineA
{
    if (nil == _lineA)
    {
        _lineA = [[UIView alloc] init];
        _lineA.backgroundColor = UICOLOR_FROM_RGB_OxFF(0xdcdcdc);
    }
    return _lineA;
}

- (UIView *)lineB
{
    if (nil == _lineB)
    {
        _lineB = [[UIView alloc] init];
        _lineB.backgroundColor = UICOLOR_FROM_RGB_OxFF(0xdcdcdc);
    }
    return _lineB;
}

- (UITableView *)leftTableView
{
    if (nil == _leftTableView)
    {
        _leftTableView = [[UITableView alloc] init];
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTableView.rowHeight = 35;
        _leftTableView.dataSource = (id)self;
        _leftTableView.delegate = (id)self;
    }
    return _leftTableView;
}

- (UITableView *)middleTableView
{
    if (nil == _middleTableView)
    {
        _middleTableView = [[UITableView alloc] init];
        _middleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _middleTableView.rowHeight = 35;
        _middleTableView.dataSource = (id)self;
        _middleTableView.delegate = (id)self;
    }
    return _middleTableView;
}

- (UITableView *)rightTableView
{
    if (nil == _rightTableView)
    {
        _rightTableView = [[UITableView alloc] init];
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rightTableView.rowHeight = 35;
        _rightTableView.dataSource = (id)self;
        _rightTableView.delegate = (id)self;
    }
    return _rightTableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
