//
//  ViewController.m
//  ReachabilityCopy
//
//  Created by Kentaro Miura on 2017/01/24.
//
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;

@property (weak, nonatomic) IBOutlet UILabel *remoteHostLabel;
@property (weak, nonatomic) IBOutlet UIImageView *remoteHostImageView;
@property (weak, nonatomic) IBOutlet UITextField *remoteHostTextFieldView;

@property (weak, nonatomic) IBOutlet UILabel *internetConnectionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *internetConnectionImageView;
@property (weak, nonatomic) IBOutlet UITextField *internetConnectionTextFieldView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
