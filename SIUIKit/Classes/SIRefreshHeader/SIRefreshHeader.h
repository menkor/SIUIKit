//
//  SIRefreshHeader.h
//
//  Created by Ye Tao on 2017/3/3.
//
//

#import "SIRefreshHeaderDef.h"
#import <MJRefresh/MJRefreshAutoNormalFooter.h>
#import <MJRefresh/MJRefreshHeader.h>

/*!
 @brief 下拉刷新的头部
 @code
 //add header
  weakify(self);
 SIRefreshHeader *header = [SIRefreshHeader headerWithStyle:SIRefreshHeaderStyleGray refreshingBlock:^{
    [weak_self startRequestData:YES];
 }];
 self.tableView.mj_header = header;
 
//stop pulling
 SIRefreshHeader *header = (SIRefreshHeader *)self.tableView.mj_header;
 [header finish];

 */

@interface SIRefreshHeader : MJRefreshHeader

/*!
 *  @brief 自定义下拉列表样式
 *  @param style           Gray,White,Red
 *  @param refreshingBlock 在此block发送请求
 *  @return SIRefreshHeader的实例
 */
+ (instancetype)headerWithStyle:(SIRefreshHeaderStyle)style refreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock;

/*!
 *  @param timeout 超时,默认3秒
 */
- (void)setTimeout:(NSTimeInterval)timeout;

/*!
 *  @brief 设置下拉完成.
 */
- (void)finish;

/*!
 *  @brief 设置下拉失败
 */
- (void)fail;

@end
