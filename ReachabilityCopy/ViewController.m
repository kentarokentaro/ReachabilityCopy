//
//  ViewController.m
//  ReachabilityCopy
//
//  Created by Kentaro Miura on 2017/01/24.
//
//

#import "ViewController.h"
#import "ReachabilityCopy.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;

@property (weak, nonatomic) IBOutlet UILabel *remoteHostLabel;
@property (weak, nonatomic) IBOutlet UIImageView *remoteHostImageView;
@property (weak, nonatomic) IBOutlet UITextField *remoteHostTextFieldView;

@property (weak, nonatomic) IBOutlet UILabel *internetConnectionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *internetConnectionImageView;
@property (weak, nonatomic) IBOutlet UITextField *internetConnectionTextFieldView;

@property (nonatomic) ReachabilityCopy *hostReachability;
@property (nonatomic) ReachabilityCopy *internetReachability;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //通信状況が変わる際に、都度通知される
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*!
 * Called by Reachability whenever status changes.
 */
- (void)reachabilityChanged:(NSNotification *)note
{
    ReachabilityCopy* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[ReachabilityCopy class]]);
    [self updateInterfaceWithReachability:curReach];
}

- (void)updateInterfaceWithReachability:(ReachabilityCopy *)reachability
{
    if(reachability == self.hostReachability)
    {
        
    }
    
}

- (void)configureTextField:(UITextField *)textField imageView:(UIImageView *)imageView reachabililty:(ReachabilityCopy *)reachability
{

}


//
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

@end
