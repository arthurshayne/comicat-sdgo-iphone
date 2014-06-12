//
//  GundamOrigin.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 6/12/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "GundamOrigin.h"

@implementation GundamOrigin

+ (NSArray *)origins {
    static NSArray *_origins;
    if (!_origins) {
        _origins = [NSArray arrayWithObjects:@"01", @"02", @"03", @"04", @"05", @"06", @"07", @"19", @"08", @"09", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"20", @"21", @"22", nil];
    }
    return _origins;
}

+ (NSDictionary *)originTitles {
    static NSDictionary *_originTitles;
    if (!_originTitles) {
        _originTitles = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"机动战士 高达", @"01",
                         @"机动战士 高达 08MS小队", @"02",
                         @"机动战士 高达 0080", @"03",
                         @"机动战士 高达 0083", @"04",
                         @"机动战士 Z高达", @"05",
                         @"机动战士 高达ZZ", @"06",
                         @"机动战士 高达 逆袭的夏亚", @"07",
                         @"机动战士 高达 UC", @"19",
                         @"机动战士 高达 F91", @"08",
                         @"机动战士 V高达", @"09",
                         @"机动武斗传 G高达", @"10",
                         @"新机动战记 高达W", @"11",
                         @"新机动战记 高达W 无尽的华尔兹", @"12",
                         @"新机动世纪 高达X", @"13",
                         @"倒A 高达", @"14",
                         @"机动战士 高达 SEED", @"15",
                         @"机动战士 高达 SEED-DESTINY", @"16",
                         @"BB战士 三国传 风云豪杰篇", @"17",
                         @"机动战士 高达00", @"18",
                         @"机动战士高达AGE", @"20",
                         @"模型战士 高达模型大师 BEGINNING G", @"21",
                         @"高达创战者", @"22", nil];
    }
    return _originTitles;
}

+ (NSDictionary *)originShortTitles {
    static NSDictionary *_originShortTitles;
    if (!_originShortTitles) {
        _originShortTitles = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"高达", @"01",
                              @"08MS", @"02",
                              @"0080", @"03",
                              @"0083", @"04",
                              @"Z", @"05",
                              @"ZZ", @"06",
                              @"逆袭的夏亚", @"07",
                              @"UC", @"19",
                              @"F91", @"08",
                              @"V", @"09",
                              @"G", @"10",
                              @"W", @"11",
                              @"W 华尔兹", @"12",
                              @"X", @"13",
                              @"倒A", @"14",
                              @"SEED", @"15",
                              @"SEED-D", @"16",
                              @"三国风云", @"17",
                              @"00", @"18",
                              @"AGE", @"20",
                              @"BEGINNING G", @"21",
                              @"BF", @"22", nil];
    }
    return _originShortTitles;
}

@end
