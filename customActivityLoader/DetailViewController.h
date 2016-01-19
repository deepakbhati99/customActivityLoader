//
//  DetailViewController.h
//  customActivityLoader
//
//  Created by Himanshu Khatri on 1/19/16.
//  Copyright © 2016 bdAppManiac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

