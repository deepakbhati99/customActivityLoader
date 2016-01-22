//
//  MasterViewController.m
//  customActivityLoader
//
//  Created by Himanshu Khatri on 1/19/16.
//  Copyright © 2016 bdAppManiac. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "AppDelegate.h"
@interface MasterViewController (){
    runningView *customLoader;
}


@property NSMutableArray *objects;
@property NSMutableArray *colorArray;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];

    NSString *color=@"color";
    NSString *name=@"name";
    _colorArray =[@[[UIColor blackColor],[UIColor darkGrayColor],[UIColor lightGrayColor],[UIColor whiteColor],[UIColor grayColor],[UIColor redColor],[UIColor greenColor],[UIColor blueColor],[UIColor cyanColor],[UIColor yellowColor],[UIColor magentaColor],[UIColor orangeColor],[UIColor purpleColor],[UIColor brownColor]] mutableCopy];
    _colorArray = [ @[@{
                          color:[UIColor blackColor],
                          name:@"black"
                          
                          },@{
                          color:[UIColor darkGrayColor],
                          name:@"darkGrayColor"
                          
                          },@{
                          color:[UIColor lightGrayColor],
                          name:@"lightGrayColor"
                          
                          },@{
                          color:[UIColor whiteColor],
                          name:@"whiteColor"
                          
                          },@{
                          color:[UIColor grayColor],
                          name:@"grayColor"
                          
                          },@{
                          color:[UIColor redColor],
                          name:@"redColor"
                          
                          },@{
                          color:[UIColor greenColor],
                          name:@"greenColor"
                          
                          },@{
                          color:[UIColor blueColor],
                          name:@"blueColor"
                          
                          },@{
                          color:[UIColor cyanColor],
                          name:@"cyanColor"
                          
                          },@{
                          color:[UIColor yellowColor],
                          name:@"yellowColor"
                          
                          },@{
                          color:[UIColor orangeColor],
                          name:@"orangeColor"
                          
                          },@{
                          color:[UIColor purpleColor],
                          name:@"purpleColor"
                          
                          },@{
                          color:[UIColor brownColor],
                          name:@"brownColor"
                          
                          }
                      ]mutableCopy];

}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    
    if (!_colorArray.count) {
        return;
    }
    
    [self.objects insertObject:_colorArray.lastObject atIndex:0];
    [_colorArray removeLastObject];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    AppDelegate *appDel=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    CGRect frame=self.view.frame;
    customLoader=[[runningView alloc]initWithFrame:frame];// ballColor:[UIColor blackColor] ballDiameter:10.0];
    [appDel.window addSubview:customLoader];
    [customLoader startAnimating];
    
    // Delay execution of my block for 10 seconds.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [customLoader stopAnimating];
    });
    
}
-(void)done{
            [customLoader stopAnimating];
}
#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        id object = self.objects[indexPath.row];
        [self addLoaderOfColor:object[@"color"]]; 
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View
-(void)addLoaderOfColor:(UIColor *)color{
    AppDelegate *appDel=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    CGRect frame=self.view.frame;
    customLoader=[[runningView alloc]initWithFrame:frame ballColor:color ballDiameter:10.0];
    [appDel.window addSubview:customLoader];
    [customLoader startAnimating];
    
    // Delay execution of my block for 10 seconds.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [customLoader stopAnimating];
    });

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    id object = self.objects[indexPath.row];
    cell.textLabel.text = object[@"name"];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

@end



