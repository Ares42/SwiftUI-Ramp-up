//
//  HealthKitManager.m
//  AppleRamp
//
//  Created by Luke Solomon on 12/16/20.
//

#import "HealthKitManager.h"

typedef void (^HealthCompletionBlock)(BOOL success);


@implementation HealthKitManager

//@synthesize property


+ (id)shared {
  static HealthKitManager *sharedManager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedManager = [[self alloc] init];
    });
  return sharedManager;
}

- (id)init {
  if (self = [super init]) {
//    initialize a property here
  }
  return self;
}

- (void)requestAuthorizationWithCompletion:(HealthCompletionBlock)completion {
  if ([HKHealthStore isHealthDataAvailable]) {
    completion(YES);
  } else {
    completion(NO);
  }
}

- (void)fetchStepsData {
  
}

@end
