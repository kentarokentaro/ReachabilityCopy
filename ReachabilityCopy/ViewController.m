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
    
    // 通信状況が変わる際に、都度通知される
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    // 表示文言
    NSString *remoteHostName = @"www.google.co.jp";
    NSString *remoteHostLabelFormatString = NSLocalizedString(@"Remote Host: %@", @"Remoete host label format string");
    self.remoteHostLabel.text = [NSString stringWithFormat:remoteHostLabelFormatString, remoteHostName];

    self.hostReachability = [ReachabilityCopy reachabilityWithHostName:remoteHostName];
    [self.hostReachability startNotifier];
    [self updateInterfaceWithReachability:self.hostReachability];

    self.internetReachability = [ReachabilityCopy reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    [self updateInterfaceWithReachability:self.internetReachability];
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
        [self configureTextField:self.remoteHostTextFieldView imageView:self.remoteHostImageView reachabililty:reachability];
        NetworkStatus netStatus = [reachability currentRechabilityStatus];
        BOOL connectionRequired = [reachability connectionRequired];
        
        self.summaryLabel.hidden = (netStatus != ReachableViaWWAN);
        NSString* baseLabelText = @"";
        
        if (connectionRequired)
        {
            baseLabelText = NSLocalizedString(@"Celluar data network is available\nInternet taraffic will be routed through it after a connection is established", @"Reachability text if a connection is required");
        }
        else
        {
            baseLabelText = NSLocalizedString(@"Celluar data network is active.\nInternet traffic will be routed through it.", @"Reachability text if a conection is not required");
        }
        self.summaryLabel.text = baseLabelText;
    }
    
    if (reachability == self.internetReachability)
    {
        [self configureTextField:self.internetConnectionTextFieldView imageView:self.internetConnectionImageView reachabililty:reachability];
    }
    
}

- (void)configureTextField:(UITextField *)textField imageView:(UIImageView *)imageView reachabililty:(ReachabilityCopy *)reachability
{
    NetworkStatus netStatus = [reachability currentRechabilityStatus];
    BOOL cconnectionRequired = [reachability connectionRequired];
    NSString* statusString = @"";
    
    switch (netStatus)
    {
        case NotReachable:
            statusString = NSLocalizedString(@"Access Not Available", @"Text field text for access is not available");
            imageView.image = [UIImage imageNamed:@"stop-32.png"];
            cconnectionRequired = NO;
            break;
        case ReachableViaWWAN:
            statusString = NSLocalizedString(@"Reachable WWAN", @"");
            imageView.image = [UIImage imageNamed:@"WWAN5.png"];
            break;
        case ReachableViaWiFi:
            statusString = NSLocalizedString(@"Reachable WiFi", @"");
            imageView.image = [UIImage imageNamed:@"Airport.png"];
            break;
    }
    
    if (cconnectionRequired)
    {
        NSString *connectionRequiredFormatString = NSLocalizedString(@"%@, Conncetion Required", @"Concatenation of status string with connection requirement");
        statusString = [NSString stringWithFormat:connectionRequiredFormatString, statusString];
    }
    textField.text = statusString;
    
}


//
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

@end
