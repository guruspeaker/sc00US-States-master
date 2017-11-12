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
@property (nonatomic, strong)NSDictionary* StateDict;
@property (nonatomic, strong)NSArray* firstLetterndx;
@end

@implementation StatesTableViewController

- (void)viewDidLoad {
    
    // Bundle: Used to get file - get the path to the pList from the bundle
    // See Bundle identifyer in info.plist
    NSString* path = [[NSBundle mainBundle]pathForResource:@"USStates" ofType:@"plist"];
    _data = [NSDictionary dictionaryWithContentsOfFile:path];
    
    // Create arrays for various datasets in _data
    NSArray* stateName = [_data objectForKey:@"stateName"];
    NSArray* YearJoinedUnion = [_data objectForKey:@"YearJoinedUnion"];
    NSArray* flagLGPath = [_data objectForKey:@"flagLGPath"];
    NSArray* flagSMPath = [_data objectForKey:@"flagSMPath"];
    NSArray* motto = [_data objectForKey:@"motto"];
    NSArray* capitalCity = [_data objectForKey:@"capitalCity"];
    NSArray* Population = [_data objectForKey:@"Population"];
    
    // Create an index of first letters
    NSMutableArray* firstLetter = [NSMutableArray arrayWithArray:stateName];
    for (int i=0;i<[firstLetter count];i++)
        {firstLetter[i]=[firstLetter[i] substringToIndex:1];}
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES];
    _firstLetterndx = [[NSSet setWithArray:firstLetter] sortedArrayUsingDescriptors:[NSArray arrayWithObject: sort]];

    // Create a Dictionary of startDictionaries
    NSMutableDictionary *StateDictionaries = [[NSMutableDictionary alloc] init];
    // // Go through each firstLetter one at a time
    for (int i=0;i<[_firstLetterndx count];i++)
    {
        // Create a temp array for collecting and holding states dictionaries
        NSMutableArray *SD1 = [[NSMutableArray alloc] init];

        for (int j=0;j<[stateName count];j++)
        {
            // If the state[j] starts with the letter[i]
            if ([stateName[j] substringToIndex:1] == _firstLetterndx[i])
            {
                // create a new state dictionary with the item.
                NSDictionary *StatePackageDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                       stateName[j],@"dStateName",
                                                       YearJoinedUnion[j],@"dYearJoinedUnion",
                                                       flagLGPath[j], @"dFlagLGPath",
                                                       flagSMPath[j], @"dFlagSMPath",
                                                       motto[j], @"dMotto",
                                                       capitalCity[j], @"dCapitalCity",
                                                       Population[j], @"dPopulation", nil];
                // Add this card to the temp array
                [SD1 addObject:StatePackageDictionary];
            }
        }
        // Add array of Dictionaries to Master Dictionary List with a key of firstletter
        StateDictionaries[_firstLetterndx[i]] = SD1;
        
    }
    
    // Convert mutable dictionary to dictionary:
    _StateDict = StateDictionaries;
    
    // Create array of keys sorted by state name
    self.keys = [[self.StateDict allKeys]sortedArrayUsingSelector:@selector(compare:)];
    
    //initialize holding array for stateinfo objects (for segue transfer)
    _usStates = [NSMutableArray arrayWithCapacity:[stateName count]];

    //Populate holdin array with items from list
    for (int i=0;i<[stateName count];i++)
    {
        stateInfo* stateDataPack = [[stateInfo alloc]init];
        stateDataPack.astateName = stateName[i];
        stateDataPack.aYearJoinedUnion = YearJoinedUnion[i];
        stateDataPack.flagLG =[UIImage imageNamed:flagLGPath[i]];
        stateDataPack.flagSM =[UIImage imageNamed:flagSMPath[i]];
        stateDataPack.amotto = motto[i];
        stateDataPack.acapitalCity = capitalCity[i];
        stateDataPack.aPopulation = Population[i];
        
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
    return [self.keys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString* key = _firstLetterndx[section];

    //for each key (letter) get an array
    NSArray* keyValues = self.StateDict[key];
    return [keyValues count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"stateInfoCellID";
    StateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Populate Cell With Data
    // -Configure the cell...
    // --Find the letter
    NSString* key = _firstLetterndx[indexPath.section];

    // --Extract letter dictionary
    NSDictionary *tempStateDict = self.StateDict[key];
    
    // --Create array of states from statename key for section
    NSArray* keyValues = [tempStateDict valueForKey:@"dStateName"];

    // ---Create array of section counts
    NSUInteger stateInfoRecord[[keyValues count]];
    
    NSArray* stateName = [_data objectForKey:@"stateName"];
    for (int i=0;i<[keyValues count];i++)
    {
        stateInfoRecord[i] = [stateName indexOfObject:keyValues[i]];
    }
    
    cell.stateName.text = keyValues[indexPath.row];
    // Using statename, look-up index value of record (to lookup in master)
    NSUInteger indexValue = [stateName indexOfObject:keyValues[indexPath.row]];

    // Get master record data
    stateInfo *item = [_usStates objectAtIndex:indexValue];

    // Get flag image from path from master data
    cell.flagImageView.image = item.flagSM;
    
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier]isEqualToString:@"sguShowDetail"])
    {
       
        
        StateDetailViewController *detailVC = [segue destinationViewController];

        // Create array of stateNames from master _data
        NSArray* stateNameList = [_data objectForKey:@"stateName"];
        
        // Return value of state selected
        NSString *selectedState = [NSString stringWithFormat:@"%@",[sender stateName].text];
        
        // Return index of that state in master array
        NSUInteger indexValue = [stateNameList indexOfObject:selectedState];
        
        // create stateInfo object for transport using index and master table
        stateInfo* item = [self.usStates objectAtIndex:indexValue];
        
        // Send it!
        detailVC.myState = item;

    }
}


@end

