//
//  DLContactManager.m
//  Dolores
//
//  Created by Heath on 12/05/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "DLContactManager.h"
#import "DLNetworkService.h"
#import "RLMRealm.h"
#import "RMDepartment.h"
#import "NSString+YYAdd.h"
#import "DLDBQueryHelper.h"
#import "DLNetworkService+DLAPI.h"

@implementation DLContactManager

+ (instancetype)sharedInstance {
    static DLContactManager *_sharedContactManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedContactManager = [[DLContactManager alloc] init];
    });
    
    return _sharedContactManager;
}

- (void)syncOrganization {
    [[DLNetworkService syncOrganization:[DLDBQueryHelper currentUser].orgVersion] subscribeNext:^(id x) {

    } error:^(NSError *error) {

    }];
}

- (void)fetchOrganization {
    [[SharedNetwork rac_GET:@"/api/v1/organization" parameters:@{}] subscribeNext:^(NSDictionary *resp) {

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            RLMRealm *realm = [RLMRealm defaultRealm];

            RMUser *loginUser = [DLDBQueryHelper currentUser];
            if (![loginUser isInvalidated]) {
                [realm transactionWithBlock:^{
                    loginUser.orgVersion = resp[@"version"];
                }];
            }

            NSArray *departments = resp[@"departments"];

            for (NSDictionary *departmentDict in departments) {
                @autoreleasepool {
                    NSString *dpId = departmentDict[@"id"];
                    if (dpId) {
                        RMDepartment *rmDepartment = [[RMDepartment alloc] initWithId:dpId name:departmentDict[@"cn"] description:departmentDict[@"description"]];
                        NSString *parentId = departmentDict[@"pid"];
                        if ([parentId isNotBlank]) {
                            RMDepartment *parentDep = [RMDepartment objectForPrimaryKey:parentId];
                            if (!parentDep.isInvalidated) {

                                [realm beginWriteTransaction];
                                rmDepartment.parentDep = parentDep;
                                [realm addOrUpdateObject:rmDepartment];
                                [parentDep.childrenDepartments addObject:rmDepartment];
                                [realm addOrUpdateObject:parentDep];
                                [realm commitWriteTransaction];
                            }
                        } else {

                            [realm beginWriteTransaction];
                            [realm addOrUpdateObject:rmDepartment];
                            [realm commitWriteTransaction];
                        }
                    }
                }
            }


            NSArray *staffs = resp[@"members"];
            for (NSDictionary *staffDict in staffs) {
                @autoreleasepool {
                    NSString *uid = staffDict[@"id"];
                    if (uid) {
                        RMStaff *rmStaff = [[RMStaff alloc] initWithDict:staffDict];
                        NSArray *belongDepartments = staffDict[@"unitID"];

                        if (belongDepartments.count > 0) {
                            RLMResults<RMDepartment *> *staffDepartments = [DLDBQueryHelper departmentsInList:belongDepartments];
                            [realm beginWriteTransaction];
                            [realm addOrUpdateObject:rmStaff];
                            for (int i = 0; i < staffDepartments.count; ++i) {
                                RMDepartment *department = [staffDepartments objectAtIndex:i];
                                if (!department.isInvalidated) {
                                    [department.staffs addObject:rmStaff];
                                    [realm addOrUpdateObject:department];
                                }
                            }
                            [realm commitWriteTransaction];
                        }
                    }
                }

            }

        });


    } error:^(NSError *error) {
        
    }];
}

@end
