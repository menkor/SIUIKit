//
//  SIGlobalFlag.h
//  SuperId
//
//  Created by Ye Tao on 2018/1/25.
//  Copyright © 2018年 SuperId. All rights reserved.
//

#ifndef SIGlobalFlag_h
#define SIGlobalFlag_h

//调试URL请求,相关类 SIURLProtocol
//#define SI_FLAG_DEBUG_URL 1

//后面.点击10次出现服务器设置
#define SI_FLAG_BACKD00R 1

//是否输出TTY日志
#define SI_FLAG_LOG 1

//文件日志
#ifdef SI_FLAG_LOG
#define SI_FLAG_LOG_FILE 1
#endif

//日志浏览器服务
#ifdef SI_FLAG_LOG
#define SI_FLAG_LOG_SERVER 1
#endif

//日志浏览器服务端口
#define SI_FLAG_LOG_SERVER_PORT 19998

//文件浏览器服务
#define SI_FLAG_FILE_SERVER 1

//文件浏览器服务端口
#define SI_FLAG_FILE_SERVER_PORT 19999

#endif /* SIGlobalFlag_h */
