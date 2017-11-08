//
//  stateInfo.h
//  sc00US-States
//
//  Created by PAUL CHRISTIAN on 11/1/17.
//  Copyright © 2017 PAUL CHRISTIAN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> //need for UIImage

@interface stateInfo : NSObject
@property (nonatomic, strong)NSString* astateName;
@property (nonatomic, strong)NSString* aYearJoinedUnion;
@property (nonatomic, strong)UIImage* flagLG;
@property (nonatomic, strong)UIImage* flagSM;
@property (nonatomic, strong)NSString* amotto;
@property (nonatomic, strong)NSString* acapitalCity;
@property (nonatomic, strong)NSNumber* aPopulation;
@end
