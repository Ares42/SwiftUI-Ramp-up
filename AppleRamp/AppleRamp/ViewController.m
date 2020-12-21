//
//  ViewController.m
//  AppleRamp
//
//  Created by Luke Solomon on 12/16/20.
//

#import "ViewController.h"
#import "HealthKitManager.h"

typedef void (^HealthCompletionBlock)(BOOL success);

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIStackView *containerView;
@property (weak, nonatomic) IBOutlet UIStackView *heartRateContainerView;
@property (weak, nonatomic) IBOutlet UIStackView *stepsContainerView;

@property (weak, nonatomic) IBOutlet UILabel *heartRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepsLabel;


@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  [[HealthKitManager shared] requestAuthorizationWithCompletion:^(BOOL success) {
    if (success) {
      [self refreshViews];
    } else {
      
    }
  }];
}

- (void)refreshViews {
  
  
  
}

@end
