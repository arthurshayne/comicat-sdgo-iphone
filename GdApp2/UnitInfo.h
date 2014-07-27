//
//  UnitInfo.h
//  GdApp2
//
//  Created by Guo, Xing Hua on 5/7/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AutoCoding.h"
#import "UnitMixMaterial.h"

@interface UnitInfo : NSObject

@property (strong, nonatomic) NSDate *generated;

// basic
@property (strong, nonatomic) NSString *unitId;
@property (strong, nonatomic) NSString *modelName;
@property (strong, nonatomic) NSString *rank;
@property (strong, nonatomic) NSString *warType;
@property (strong, nonatomic) NSString *landform;
@property int origin;
@property (strong, nonatomic) NSString *originTitle;
@property (strong, nonatomic) NSString *story;
@property (strong, nonatomic) NSString *regdate;
@property (strong, nonatomic) NSString *driver;
@property (strong, nonatomic) NSString *feature;
@property (strong, nonatomic) NSString *howToGet;

// 4p
@property BOOL sniping;
@property BOOL modification;
@property BOOL oversize;
@property BOOL repair;

// stats
@property float attackG;
@property float defenseG;
@property float mobilityG;
@property float controlG;

@property (readonly) float sum3D;
@property (readonly) float sum4D;

// weapons
@property uint weapon1;
@property uint weapon2;
@property uint weapon3;
@property uint weapon4;
@property uint weapon5;
@property uint weapon6;
@property (strong, nonatomic) NSString *weaponName1;
@property (strong, nonatomic) NSString *weaponName2;
@property (strong, nonatomic) NSString *weaponName3;
@property (strong, nonatomic) NSString *weaponName4;
@property (strong, nonatomic) NSString *weaponName5;
@property (strong, nonatomic) NSString *weaponName6;
@property (strong, nonatomic) NSString *weaponEffect1;
@property (strong, nonatomic) NSString *weaponEffect2;
@property (strong, nonatomic) NSString *weaponEffect3;
@property (strong, nonatomic) NSString *weaponEffect4;
@property (strong, nonatomic) NSString *weaponEffect5;
@property (strong, nonatomic) NSString *weaponEffect6;
@property (strong, nonatomic) NSString *weaponProperty1;
@property (strong, nonatomic) NSString *weaponProperty2;
@property (strong, nonatomic) NSString *weaponProperty3;
@property (strong, nonatomic) NSString *weaponProperty4;
@property (strong, nonatomic) NSString *weaponProperty5;
@property (strong, nonatomic) NSString *weaponProperty6;

@property (strong, nonatomic) NSString *weaponRange1;
@property (strong, nonatomic) NSString *weaponRange2;
@property (strong, nonatomic) NSString *weaponRange3;
@property (strong, nonatomic) NSString *weaponRange4;
@property (strong, nonatomic) NSString *weaponRange5;
@property (strong, nonatomic) NSString *weaponRange6;

@property (strong, nonatomic) NSString *weaponEx1Line1;
@property (strong, nonatomic) NSString *weaponEx1Line2;
@property (strong, nonatomic) NSString *weaponEx2Line1;
@property (strong, nonatomic) NSString *weaponEx2Line2;
@property (strong, nonatomic) NSString *weaponEx3Line1;
@property (strong, nonatomic) NSString *weaponEx3Line2;
@property (strong, nonatomic) NSString *weaponEx4Line1;
@property (strong, nonatomic) NSString *weaponEx4Line2;
@property (strong, nonatomic) NSString *weaponEx5Line1;
@property (strong, nonatomic) NSString *weaponEx5Line2;
@property (strong, nonatomic) NSString *weaponEx6Line1;
@property (strong, nonatomic) NSString *weaponEx6Line2;

@property (readonly) uint numberOfWeapons;

// skills
@property uint skill1;
@property uint skill2;
@property uint skill3;
@property (strong, nonatomic) NSString *skillName1;
@property (strong, nonatomic) NSString *skillName2;
@property (strong, nonatomic) NSString *skillName3;
@property (strong, nonatomic) NSString *skillDesc1;
@property (strong, nonatomic) NSString *skillDesc2;
@property (strong, nonatomic) NSString *skillDesc3;
@property (strong, nonatomic) NSString *skillEx1;
@property (strong, nonatomic) NSString *skillEx2;
@property (strong, nonatomic) NSString *skillEx3;

@property uint ratings;
@property float ratingValue;

@property (strong, nonatomic) NSString *groupName1;
@property (strong, nonatomic) NSString *groupName2;

@property (strong, nonatomic) NSString *shopBuy;
@property (strong, nonatomic) NSString *shopBuyPrice;
@property (strong, nonatomic) NSString *shopRissCash;
// @property (strong, nonatomic) NSString *shopRissCashPrice;
@property (strong, nonatomic) NSString *shopRissPoint;
// @property (strong, nonatomic) NSString *shopRissPointPrice;
@property (strong, nonatomic) NSString *shopMixBuy;
@property (strong, nonatomic) NSString *etc;
@property (strong, nonatomic) NSString *capsule1;
@property (strong, nonatomic) NSString *capsule2;
@property (strong, nonatomic) NSString *capsule3;
@property (strong, nonatomic) NSString *capsule4;
@property (strong, nonatomic) NSString *quest1;
@property (strong, nonatomic) NSString *quest2;
@property (strong, nonatomic) NSString *mission1;
@property (strong, nonatomic) NSString *mission2;
@property (strong, nonatomic) NSString *mission3;
@property (strong, nonatomic) NSString *mission4;
@property (strong, nonatomic) NSString *mission5;
@property (strong, nonatomic) NSString *lab1;
@property (strong, nonatomic) NSString *lab2;

@property (strong, nonatomic) NSArray *videoList;  // array of VideoListItem

@property (strong, nonatomic) UnitMixMaterial *mixingKeyUnit;
@property (strong, nonatomic) NSArray *mixingMaterialUnits; // array of UnitMixMaterial

@property (strong, nonatomic) UnitMixMaterial *mixingKeyUnitCN;
@property (strong, nonatomic) NSArray *mixingMaterialUnitsCN; // array of UnitMixMaterial

@property (strong, nonatomic) NSArray *canMixAsKey; // array of UnitMixMaterial
@property (strong, nonatomic) NSArray *canMixAsMaterial; // array of UnitMixMaterial

@end
