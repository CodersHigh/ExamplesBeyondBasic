//
//  PosterModel.m
//  CinemaKid-ObjC
//
//  Created by Abraham Park on 5/21/17.
//  Copyright © 2017 ebadaq.com. All rights reserved.
//

#import "PosterModel.h"

@interface PosterModel()

@property (nonatomic, strong) NSOperationQueue *queueSub;
@property (nonatomic, strong) NSMutableDictionary *dicCache;
@property (nonatomic, strong) NSMutableDictionary *dicBlockUpdate;
@end

@implementation PosterModel

- (NSOperationQueue *)queueSub{
    if (_queueSub == nil) {
        _queueSub = [[NSOperationQueue alloc] init];
    }
    return _queueSub;
}

- (NSMutableDictionary *)dicCache{
    if (_dicCache == nil) {
        _dicCache = [@{} mutableCopy];
    }
    return _dicCache;
}

- (NSMutableDictionary *)dicBlockUpdate{
    if (_dicBlockUpdate == nil) {
        _dicBlockUpdate = [@{} mutableCopy];
    }
    return _dicBlockUpdate;
}

/** 이미지 업데이트 연결. */
- (void) requestPoster:(NSString *)posterCode afterUpdate:(BlockAfterUpdate) blockUpdate{
    NSData *dataImage = self.dicCache[posterCode]; // 캐시에서 꺼내온다.
    
    if (dataImage == nil) {
        self.dicBlockUpdate[posterCode] = blockUpdate; // 프로세스 저장. - 원래는 복사를 한번 했는데... 안해도 되려나..
        
        //NSString *stringURL = @"http://192.168.197.138/CinemaKid/movie/stillcut/";
        NSString *stringURL = @"http://z.ebadaq.com:45070/CinemaKid/movie/stillcut/";
        
        stringURL = [stringURL stringByAppendingPathComponent:posterCode];
        
        NSURL *url = [NSURL URLWithString:stringURL];
        
        id __weak selfWeak = self;
        
        [self.queueSub addOperationWithBlock:^{
            NSData *data = [NSData dataWithContentsOfURL:url];
            
            PosterModel *selfStrong = selfWeak;
            
            if (data && selfStrong) {
                selfStrong.dicCache[posterCode] = data; // 받은 이미지 바이너리 캐시에 저장.
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    BlockAfterUpdate update = selfStrong.dicBlockUpdate[posterCode]; // 저장된 업데이트 프로세스 이용.
                    
                    if (update) {
                        update(data);
                        NSLog(@"다운 받아서 업데이트 중");
                    }
                }];
            }
        }];
    }
    else{ // 메인 쓰레드에서 불렀을꺼야.. -.-;;
        if (blockUpdate) {
            blockUpdate(dataImage);
            NSLog(@"캐시에서 땡겨왔음");
        }
    }
}

@end
