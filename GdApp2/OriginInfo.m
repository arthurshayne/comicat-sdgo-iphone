//
//  OriginInfo.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 6/18/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "OriginInfo.h"

@implementation OriginInfo

+ (OriginInfo *)originWithOriginIndex:(NSString *)originIndex
                                title:(NSString *)title
                           shortTitle:(NSString *)shortTitle
                        numberOfUnits:(uint)numberOfUnits {
    OriginInfo *origin = [[OriginInfo alloc] init];
    origin.originIndex = [originIndex copy];
    origin.title = [title copy];
    origin.shortTitle = [shortTitle copy];
    origin.numberOfUnits = numberOfUnits;
    
    return origin;
}

+ (NSArray *)builtInOrigins {
    return [NSArray arrayWithObjects:
            [OriginInfo originWithOriginIndex:@"01" title:@"机动战士 高达" shortTitle:@"高达" numberOfUnits:79],
            [OriginInfo originWithOriginIndex:@"02" title:@"机动战士 高达 08MS小队" shortTitle:@"08MS" numberOfUnits:21],
            [OriginInfo originWithOriginIndex:@"03" title:@"机动战士 高达 0080" shortTitle:@"0080" numberOfUnits:19],
            [OriginInfo originWithOriginIndex:@"04" title:@"机动战士 高达 0083" shortTitle:@"0083" numberOfUnits:31],
            [OriginInfo originWithOriginIndex:@"05" title:@"机动战士 Z高达" shortTitle:@"Z高达" numberOfUnits:70],
            [OriginInfo originWithOriginIndex:@"06" title:@"机动战士 高达ZZ" shortTitle:@"ZZ高达" numberOfUnits:35],
            [OriginInfo originWithOriginIndex:@"07" title:@"机动战士 高达 逆袭的夏亚" shortTitle:@"逆袭的夏亚" numberOfUnits:20],
            [OriginInfo originWithOriginIndex:@"19" title:@"机动战士 高达 UC" shortTitle:@"UC" numberOfUnits:40],
            [OriginInfo originWithOriginIndex:@"08" title:@"机动战士 高达 F91" shortTitle:@"F91" numberOfUnits:25],
            [OriginInfo originWithOriginIndex:@"09" title:@"机动战士 V高达" shortTitle:@"V高达" numberOfUnits:8],
            [OriginInfo originWithOriginIndex:@"10" title:@"机动武斗传 G高达" shortTitle:@"G高达" numberOfUnits:26],
            [OriginInfo originWithOriginIndex:@"11" title:@"新机动战记 高达W" shortTitle:@"高达W" numberOfUnits:20],
            [OriginInfo originWithOriginIndex:@"12" title:@"新机动战记 高达W 无尽的华尔兹" shortTitle:@"W 华尔兹" numberOfUnits:14],
            [OriginInfo originWithOriginIndex:@"13" title:@"新机动世纪 高达X" shortTitle:@"高达X" numberOfUnits:14],
            [OriginInfo originWithOriginIndex:@"14" title:@"倒A 高达" shortTitle:@"∀" numberOfUnits:4],
            [OriginInfo originWithOriginIndex:@"15" title:@"机动战士 高达 SEED" shortTitle:@"SEED" numberOfUnits:79],
            [OriginInfo originWithOriginIndex:@"16" title:@"机动战士 高达 SEED-DESTINY" shortTitle:@"SEED-D" numberOfUnits:57],
            [OriginInfo originWithOriginIndex:@"17" title:@"BB战士 三国传 风云豪杰篇" shortTitle:@"三国风云" numberOfUnits:26],
            [OriginInfo originWithOriginIndex:@"18" title:@"机动战士 高达00" shortTitle:@"高达00" numberOfUnits:96],
            [OriginInfo originWithOriginIndex:@"20" title:@"机动战士 高达AGE" shortTitle:@"高达AGE" numberOfUnits:16],
            [OriginInfo originWithOriginIndex:@"21" title:@"模型战士 高达模型大师 BEGINNING G" shortTitle:@"BEGINNING G" numberOfUnits:2],
            [OriginInfo originWithOriginIndex:@"22" title:@"高达创战者" shortTitle:@"BF" numberOfUnits:8], nil];
}

@end
