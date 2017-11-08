//
//  StatesTableViewController.m
//  sc00US-States
//
//  Created by PAUL CHRISTIAN on 11/1/17.
//  Copyright © 2017 PAUL CHRISTIAN. All rights reserved.
//

#import "StatesTableViewController.h"
#import "stateInfo.h"
#import "StateTableViewCell.h"
#import "StateDetailViewController.h"

@interface StatesTableViewController ()
@property (strong, nonatomic)NSMutableArray* usStates;
@property (nonatomic, strong)NSDictionary* data;
@property (nonatomic, strong)NSArray* keys;
@property (nonatomic, strong)NSMutableArray* firstLetter;
@property (nonatomic, strong)NSMutableArray* firstLetterCount;
@property (nonatomic, strong)NSArray* firstLetterndx;
@property (nonatomic, strong)NSArray* flagLGpath;
@property (nonatomic, strong)NSArray* YearJoinedUnion;
@property (nonatomic, strong)NSArray* flagLGPath;
@property (nonatomic, strong)NSArray* flagSMPath;
@property (nonatomic, strong)NSArray* motto;
@property (nonatomic, strong)NSArray* capitalCity;
@property (nonatomic, strong)NSArray* Population;
@end

@implementation StatesTableViewController

- (void)viewDidLoad {
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Bundle: Used to get file - get the path to the pList from the bundle
    // See Bundle identifyer in info.plist
    
    
    NSString* path = [[NSBundle mainBundle]pathForResource:@"USStates" ofType:@"plist"];
    _data = [NSDictionary dictionaryWithContentsOfFile:path];

    NSArray* stateName = [_data objectForKey:@"stateName"];
    NSArray* YearJoinedUnion = [_data objectForKey:@"YearJoinedUnion"];
    NSArray* flagLGPath = [_data objectForKey:@"flagLGPath"];
    NSArray* flagSMPath = [_data objectForKey:@"flagSMPath"];
    NSArray* motto = [_data objectForKey:@"motto"];
    NSArray* capitalCity = [_data objectForKey:@"capitalCity"];
    NSArray* Population = [_data objectForKey:@"Population"];
    
    // create an index of first letters
    NSMutableArray* firstLetter = [[NSMutableArray alloc]init];
    NSMutableArray* firstLetterCounts = [[NSMutableArray alloc] init];
    int j = 0;
    int k = 0;
    for (int i=0;i<[stateName count];i++)
    {
        NSLog(@"Processing State: %@",stateName[i]);
        if (![firstLetter containsObject:[stateName[i] substringToIndex:1]])
        {
            firstLetter[j] = [stateName[i] substringToIndex:1];
            if (j>0) firstLetterCounts[j-1] = [NSNumber numberWithInt:k];
            NSLog(@"New Entry: %@",firstLetter[j]);
            
            j++;
            k=1;
            NSLog(@"Advancing j: %i, Resetting k: %i", j, k);
        }
        else
        {
            
            k++;
            NSLog(@"Current FirstLetterCount: %@ = %i",firstLetter[j-1],k);
            
        }
    }
    firstLetterCounts[j-1] = [NSNumber numberWithInt:k];
    NSLog(@"First Letter Count: %ld",[firstLetter count]);
    self.firstLetterndx = firstLetter;
    self.keys = [[self.data allKeys]sortedArrayUsingSelector:@selector(compare:)];
    
    //[super viewDidLoad];
    // Populate lists of characteristics
    //[self AssignStateName];
    //[self AssignCapitalName];
    //[self AssignMotto];
    //[self AssignFlagSMFileName];
    //[self AssignFlagLGFileName];
    //[self AssignBirdPicFileName];
    //[self AssignBird];
    //[self AssignPopulation];
    
    //initialize holding array
    _usStates = [NSMutableArray arrayWithCapacity:50];
    
    // initialize stateDataPack instance as collector / packer for usStates
        //stateInfo* stateDataPack = [[stateInfo alloc]init];

    //Populate holdin array with items from list
    for (int i=0;i<50;i++)
    {
        stateInfo* stateDataPack = [[stateInfo alloc]init];
        stateDataPack.astateName = stateName[i];
        stateDataPack.aYearJoinedUnion = YearJoinedUnion[i];
        stateDataPack.flagLG =[UIImage imageNamed:flagLGPath[i]];
        stateDataPack.flagSM =[UIImage imageNamed:flagSMPath[i]];
        stateDataPack.amotto = motto[i];
        stateDataPack.acapitalCity = capitalCity[i];
        stateDataPack.aPopulation = Population[i];
       // NSLog(@"Pop: %@",Population[i]);

        // Pack the StateDatapackage into the usStates array
        [_usStates insertObject:stateDataPack atIndex:i];


    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
		
    // return 1;
    return [self.keys count];
}

/*- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

        //return [_usStates count];
        //return [states]
    return [_firstLetterCount[section] integerValue];
}
*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString* key = self.keys[section];
    
    // for each key get an array
    NSArray* keyValues = self.data[key];
    return [keyValues count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"stateInfoCellID";
    StateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    //Populate Cell With Data
    stateInfo *item = [_usStates objectAtIndex:indexPath.row];
    cell.stateName.text = [NSString stringWithFormat:@"%@", item.astateName];
    //cell.stateMoto.text = [NSString stringWithFormat:@"%@", item.amotto];
    cell.flagImageView.image = item.flagSM;
    
    // Configure the cell...
    
    return cell;
}
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.firstLetterndx;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier]isEqualToString:@"sguShowDetail"])
    {
        StateDetailViewController *detailVC = [segue destinationViewController];
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        stateInfo* item = [self.usStates objectAtIndex:myIndexPath.row];
        detailVC.myState = item;
        
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
}


@end
