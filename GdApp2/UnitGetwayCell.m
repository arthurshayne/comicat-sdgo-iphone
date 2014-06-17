//
//  UnitGetwayCell.m
//  GdApp2
//
//  Created by Guo, Xing Hua on 6/4/14.
//  Copyright (c) 2014 COMICAT. All rights reserved.
//

#import "UnitGetwayCell.h"

@implementation UnitGetwayCell

const CGFloat TEXT_WIDTH = 280;
const CGFloat CELL_PADDING_LEFT = 23;

+ (NSParagraphStyle *)psWide {
    static NSMutableParagraphStyle *wrapPS = nil;
    if (!wrapPS) {
        wrapPS = [[NSMutableParagraphStyle alloc] init];
        wrapPS.lineBreakMode = NSLineBreakByWordWrapping;
        wrapPS.paragraphSpacing = 8;
    }
    return wrapPS;
}

+ (NSParagraphStyle *)psNarrow {
    static NSMutableParagraphStyle *psNarrow = nil;
    if (!psNarrow) {
        psNarrow = [[NSMutableParagraphStyle alloc] init];
        psNarrow.lineBreakMode = NSLineBreakByWordWrapping;
        psNarrow.paragraphSpacing = 4;
    }
    return psNarrow;
}

- (void)setUnit:(UnitInfo *)unit {
    _unit = unit;
    [self updateGetwayText];
}

- (void)updateGetwayText {
    getwayText = nil;
    getwayText = [[self class] assembleContentText:self.unit];
}

+ (CGFloat)calculateHeightForUnit:(UnitInfo *)unit {
    NSAttributedString *attrString = [[self class] assembleContentText:unit];
    CGRect rect = [attrString boundingRectWithSize:CGSizeMake(TEXT_WIDTH, CGFLOAT_MAX)
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                           context:nil];
    return rect.size.height + 25;

}

+ (NSAttributedString *)assembleContentText:(UnitInfo *)unit {
    NSDictionary *attributeForCaption = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:12],
                                          NSForegroundColorAttributeName:[GDAppUtility UIColorFromRGB:0x354B63],
                                          NSParagraphStyleAttributeName:[[self class] psNarrow]};
    NSDictionary *attributeForText = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:12],
                                       NSForegroundColorAttributeName:[GDAppUtility UIColorFromRGB:0x5A7797],
                                       NSParagraphStyleAttributeName:[[self class] psNarrow] };
                                       
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    
    [result appendAttributedString:[[NSAttributedString alloc] initWithString:@"获取方式"
                                                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                                                                NSParagraphStyleAttributeName:[self.class psWide]}]];

    // 扭蛋
    BOOL showCapsules = NO;
    NSMutableArray *capsuleArray = [[NSMutableArray alloc] initWithCapacity:4];
    for (int i = 0; i < 4; i++) {
        NSString *capsule = [unit valueForKey:[NSString stringWithFormat:@"capsule%d", i + 1]];
        showCapsules |= (capsule.length > 0);
        [capsuleArray insertObject:capsule atIndex:i];
    }
    if (showCapsules) {
        [result appendAttributedString:
            [[NSAttributedString alloc] initWithString:@"\n扭蛋机\n\x20\x20\x20\x20"
                                            attributes:attributeForCaption]];
        for (int i = 0; i < capsuleArray.count; i++) {
            NSString *capsule = [capsuleArray objectAtIndex:i];
            if (capsule && capsule.length > 0) {
                [result appendAttributedString:
                    [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"[%@]\x20", [capsuleArray objectAtIndex:i]]
                                                    attributes:attributeForText]];
            }
        }
    }
    
    // 购买租赁
    BOOL showShop = (unit.shopBuy.length + unit.shopRissCash.length + unit.shopRissPoint.length) > 0;
    if (showShop) {
        [result appendAttributedString:
         [[NSAttributedString alloc] initWithString:@"\n购买或租赁\n\x20\x20\x20\x20"
                                         attributes:attributeForCaption]];

        if (unit.shopBuy.length > 0) {
            [result appendAttributedString:
             [[NSAttributedString alloc] initWithString:@"[可购买]\x20"
                                             attributes:attributeForText]];
        }
        if (unit.shopRissCash.length > 0) {
            [result appendAttributedString:
             [[NSAttributedString alloc] initWithString:@"[可以CASH出租]\x20"
                                             attributes:attributeForText]];
        }
        if (unit.shopRissPoint.length > 0) {
            [result appendAttributedString:
             [[NSAttributedString alloc] initWithString:@"[可以点数出租]\x20"
                                             attributes:attributeForText]];
        }
    }
    
    if (unit.shopMixBuy) {
        [result appendAttributedString:
         [[NSAttributedString alloc] initWithString:@"\n购买合成图"
                                         attributes:attributeForCaption]];

    }
    
    // Quest
    BOOL showQuests = NO;
    NSMutableArray *quests = [[NSMutableArray alloc] initWithCapacity:2];
    for (int i = 0; i < 2; i++) {
        NSString *quest = [unit valueForKey:[NSString stringWithFormat:@"quest%d", i + 1]];
        showQuests |= (quest.length > 0);
        [quests insertObject:quest atIndex:i];
    }
    if (showQuests) {
        [result appendAttributedString:
         [[NSAttributedString alloc] initWithString:@"\nQuest\n\x20\x20\x20\x20"
                                         attributes:attributeForCaption]];
        for (int i = 0; i < quests.count; i++) {
            NSString *quest = [quests objectAtIndex:i];
            if (quest && quest.length > 0) {
                [result appendAttributedString:
                 [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"[%@]\x20", [quests objectAtIndex:i]]
                                                 attributes:attributeForText]];
            }
        }
    }
    
    // Mission
    BOOL showMissions = NO;
    NSMutableArray *missions = [[NSMutableArray alloc] initWithCapacity:5];
    for (int i = 0; i < 5; i++) {
        NSString *mission = [unit valueForKey:[NSString stringWithFormat:@"mission%d", i + 1]];
        showMissions |= (mission.length > 0);
        [missions insertObject:missions atIndex:i];
    }
    if (showMissions) {
        [result appendAttributedString:
         [[NSAttributedString alloc] initWithString:@"\nMission\n\x20\x20\x20\x20"
                                         attributes:attributeForCaption]];
        for (int i = 0; i < missions.count; i++) {
            NSString *mission = [missions objectAtIndex:i];
            if (mission && mission.length > 0) {
                [result appendAttributedString:
                 [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"[%@]\x20", [missions objectAtIndex:i]]
                                                 attributes:attributeForText]];
            }
        }
    }
    
    // Labs
    BOOL showLabs = NO;
    NSMutableArray *labs = [[NSMutableArray alloc] initWithCapacity:2];
    for (int i = 0; i < 2; i++) {
        NSString *lab = [unit valueForKey:[NSString stringWithFormat:@"lab%d", i + 1]];
        showLabs |= (lab.length > 0);
        [labs insertObject:lab atIndex:i];
    }
    if (showLabs) {
        [result appendAttributedString:
         [[NSAttributedString alloc] initWithString:@"\n研究所\n\x20\x20\x20"
                                         attributes:attributeForCaption]];
        for (int i = 0; i < labs.count; i++) {
            NSString *lab = [labs objectAtIndex:i];
            if (lab && lab.length > 0) {
                [result appendAttributedString:
                 [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"[%@]\x20", [labs objectAtIndex:i]]
                                                 attributes:attributeForText]];
            }
        }
    }
    
    // etc
    if (unit.etc && [unit.etc isEqualToString:@"1"]) {
        [result appendAttributedString:
         [[NSAttributedString alloc] initWithString:@"\n特别\n\x20\x20\x20\x20"
                                         attributes:attributeForCaption]];
        [result appendAttributedString:
         [[NSAttributedString alloc] initWithString:unit.howToGet
                                         attributes:attributeForText]];
    }
    
    return result;
}

- (void)layoutSubviews
{
	CGRect b = [self bounds];
	[contentView setFrame:b];
    [super layoutSubviews];
}

- (void)drawContentView:(CGRect)r {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, [[UIColor whiteColor] CGColor]);
    CGContextFillRect(ctx, r);

    if (getwayText) {
        [getwayText drawInRect:CGRectMake(CELL_PADDING_LEFT, 10, TEXT_WIDTH, CGFLOAT_MAX)];
    }
}

@end
