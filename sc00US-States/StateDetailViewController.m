//
//  StateDetailViewController.m
//  sc00US-States
//
//  Created by PAUL CHRISTIAN on 11/1/17.
//  Copyright © 2017 PAUL CHRISTIAN. All rights reserved.
//

#import "StateDetailViewController.h"

@interface StateDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgStateFlag;
@property (weak, nonatomic) IBOutlet UILabel *lblStateMotto;
@property (weak, nonatomic) IBOutlet UILabel *lblStateCapital;
@property (weak, nonatomic) IBOutlet UILabel *lblState;
@property (weak, nonatomic) IBOutlet UILabel *lblPopulation;

@property (weak, nonatomic) IBOutlet UILabel *joinedUnion;


@end

@implementation StateDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.lblState.text = self.myState.astateName;
    self.imgStateFlag.image = self.myState.flagLG;
    self.lblStateMotto.text = [NSString stringWithFormat:@"Motto: %@", self.myState.amotto];
    self.lblStateCapital.text = self.myState.acapitalCity;
    
    NSNumberFormatter *fmtPopulation = [[NSNumberFormatter alloc] init];
    [fmtPopulation setNumberStyle:NSNumberFormatterDecimalStyle]; // to get commas (or locale equivalent)
    [fmtPopulation setMaximumFractionDigits:0]; // to avoid any decimal
    self.lblPopulation.text = [NSString stringWithFormat:@"Pop: %@", [fmtPopulation stringFromNumber:self.myState.aPopulation]];
    //self.lblPopulation.text = [NSString stringWithFormat:@"Pop: %ld", (long)self.myState.aPopulation];
    self.joinedUnion.text = [NSString stringWithFormat:@"Joined the Union: %@",self.myState.aYearJoinedUnion];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
