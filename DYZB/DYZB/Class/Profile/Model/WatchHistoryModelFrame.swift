//
//  WatchHistoryFrameModel.swift
//  DYZB
//
//  Created by xiudou on 2017/6/30.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit
fileprivate let margin : CGFloat = 10
fileprivate let room_srcHeight : CGFloat = WatchHistoryItemHeight - 2 * margin
fileprivate let room_srcWidth : CGFloat = room_srcHeight * 1.4
class WatchHistoryModelFrame: NSObject {
    
    var handleTime : String = ""

    var room_srcFrame : CGRect = CGRect.zero
    var room_nameFrame : CGRect = CGRect.zero
    var nicknameFrame : CGRect = CGRect.zero
    var show_timeFrame : CGRect = CGRect.zero
    var lineViewFrame : CGRect = CGRect.zero
    
    var watchHistoryModel : WatchHistoryModel
    
    init(_ watchHistoryModel : WatchHistoryModel) {
        self.watchHistoryModel = watchHistoryModel
        super.init()
        
        room_srcFrame = CGRect(x: margin, y: margin, width: room_srcWidth, height: room_srcHeight)
        
        let roomName = watchHistoryModel.room_name
        let width = sScreenW - room_srcFrame.maxX - margin - margin
        let size = CGSize(width: width, height: 30)
        let roomNameSize = roomName.sizeWithFont(WatchHistoryTitleLabelFont, size: size)
        room_nameFrame = CGRect(x: room_srcFrame.maxX + margin, y: room_srcFrame.origin.y + margin, width: roomNameSize.width, height: roomNameSize.height)
        
        let lt = watchHistoryModel.lt
        // TODO 处理时间.....
        handleTime = Date.createDateString(lt)
        let showTimeS = CGSize(width: width, height: 15)
        let showTimeSize = handleTime.sizeWithFont(WatchHistoryTimeLabelFont, size: showTimeS)
        show_timeFrame = CGRect(x: sScreenW - showTimeSize.width - margin, y: room_srcFrame.maxY - showTimeSize.height - 5, width: showTimeSize.width, height: showTimeSize.height)
        
        let nickName = watchHistoryModel.nickname
        let nickNameWidth = sScreenW - room_srcFrame.maxX - margin - show_timeFrame.width - margin - margin
        let nickNameS = CGSize(width: nickNameWidth, height: 15)
        let nickNameSize = nickName.sizeWithFont(WatchHistorySubTitleLabelFont, size: nickNameS)
        nicknameFrame = CGRect(x: room_nameFrame.origin.x, y: show_timeFrame.origin.y, width: nickNameSize.width, height: nickNameSize.height)
        
        lineViewFrame = CGRect(x: 0, y: WatchHistoryItemHeight - 1, width: sScreenW, height: 1)
        
    }
}
