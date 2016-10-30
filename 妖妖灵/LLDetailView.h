//
//  LLDetailView.h
//  妖妖灵
//
//  Created by Wll on 16/10/29.
//  Copyright © 2016年 CherryWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLDetailView : UIView{
    NSArray *DetailimageNameArray;
    NSArray *DetailcontextArray;
    NSArray *DetailTextBoxArray;
}
@property (nonatomic,strong) UIImageView *llDetailimage;

@property (nonatomic,strong) UILabel *llDetailContext;

@property (nonatomic,strong) UILabel *llDetailName;

@property (nonatomic,strong) UILabel *llDetailAge;

@property (nonatomic) int llDetailMonsteriD;

@end
