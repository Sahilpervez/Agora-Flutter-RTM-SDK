import AgoraRtmKit
import Flutter

extension AgoraRtmMessage {
    func toJson() -> [String: Any?] {
        switch(self){
        case let self as AgoraRtmRawMessage: return [
            "text": text,
            "rawMessage": FlutterStandardTypedData(bytes: self.rawData),
            "messageType": type.rawValue,
            "serverReceivedTs": serverReceivedTs,
            "isOfflineMessage": isOfflineMessage,
        ]
        default: return [
            "text": text,
            "messageType": type.rawValue,
            "serverReceivedTs": serverReceivedTs,
            "isOfflineMessage": isOfflineMessage,
        ]
        }
    }
}

extension AgoraRtmMember {
    func toJson() -> [String: Any?] {
        return [
            "userId": userId,
            "channelId": channelId,
        ]
    }
}

extension AgoraRtmAttribute {
    func toJson() -> [String: Any?] {
        return [
            "key": key,
            "value": value,
        ]
    }
}

extension AgoraRtmChannelAttribute {
    func toJson() -> [String: Any?] {
        return [
            "key": key,
            "value": value,
            "lastUpdateUserId": lastUpdateUserId,
            "lastUpdateTs": lastUpdateTs,
        ]
    }
}

extension AgoraRtmLocalInvitation {
    func toJson() -> [String: Any?] {
        return [
            "calleeId": calleeId,
            "content": content,
            "channelId": channelId,
            "response": response,
            "state": state.rawValue,
            "hashCode": hash,
        ]
    }
}

extension AgoraRtmRemoteInvitation {
    func toJson() -> [String: Any?] {
        return [
            "callerId": callerId,
            "content": content,
            "channelId": channelId,
            "response": response,
            "state": state.rawValue,
            "hashCode": hash,
        ]
    }
}

extension AgoraRtmChannelAttributeOptions{
    func toJson() -> [String: Any?] {
        return [
            "enableNotificationToChannelMembers": enableNotificationToChannelMembers,
        ]
    }
}

extension AgoraRtmSendMessageOptions {
    func toJson() -> [String: Any?] {
        return [:]
    }
}

extension AgoraRtmChannelMemberCount {
    func toJson() -> [String: Any?] {
        return [
            "channelId": channelId,
            "memberCount": count,
        ]
    }
}

extension AgoraRtmMetadataItem {
    func toJson() -> [String: Any?] {
        return [
            "key": key,
            "value": value,
            "revision": revision,
            "updateTs": updateTs,
            "authorUserId": authorUserId,
        ]
    }
}

extension AgoraRtmMetadata {
    func toJson() -> [String: Any?] {
        return [
            "items": items?.toJson(),
            "majorRevision": majorRevision,
        ]
    }
}

extension AgoraRtmMetadataOptions {
    func toJson() -> [String: Any?] {
        return [
            "majorRevision": majorRevision,
            "enableRecordTs": enableRecordTs,
            "enableRecordUserId": enableRecordUserId,
        ]
    }
}

extension Dictionary where Key == String {
    func toRtmMessage() -> AgoraRtmMessage {
        let text = self["text"] as? String
        if let rawMessage = self["rawMessage"] as? FlutterStandardTypedData {
            return AgoraRtmRawMessage(rawData: rawMessage.data, description: text!)
        } else {
            return AgoraRtmMessage(text: text!)
        }
    }
    
    func toRtmAttribute() -> AgoraRtmAttribute {
        let rtmAttribute = AgoraRtmAttribute()
        if let key = self["key"] as? String {
            rtmAttribute.key = key
        }
        if let value = self["value"] as? String {
            rtmAttribute.value = value
        }
        return rtmAttribute
    }
    
    func toRtmChannelAttribute() -> AgoraRtmChannelAttribute {
        let rtmAttribute = AgoraRtmChannelAttribute()
        if let key = self["key"] as? String {
            rtmAttribute.key = key
        }
        if let value = self["value"] as? String {
            rtmAttribute.value = value
        }
        return rtmAttribute
    }
    
    func toLocalInvitation(_ callManager: RTMCallManager) -> AgoraRtmLocalInvitation? {
        if let hashCode = self["hashCode"] as? Int, let localInvitation = callManager.localInvitations[hashCode] {
            localInvitation.content = self["content"] as? String
            localInvitation.channelId = self["channelId"] as? String
            return localInvitation
        }
        if let calleeId = self["calleeId"] as? String {
            let localInvitation = AgoraRtmLocalInvitation(calleeId: calleeId)
            localInvitation.content = self["content"] as? String
            localInvitation.channelId = self["channelId"] as? String
            return localInvitation
        }
        return nil
    }
    
    func toRemoteInvitation(_ callManager: RTMCallManager) -> AgoraRtmRemoteInvitation? {
        if let hashCode = self["hashCode"] as? Int, let remoteInvitation = callManager.remoteInvitations[hashCode] {
            remoteInvitation.response = self["response"] as? String
            return remoteInvitation
        }
        return nil
    }
    
    func toChannelAttributeOptions() -> AgoraRtmChannelAttributeOptions {
        let channelAttributeOptions = AgoraRtmChannelAttributeOptions()
        if let enableNotificationToChannelMembers = self["enableNotificationToChannelMembers"] as? Bool {
            channelAttributeOptions.enableNotificationToChannelMembers = enableNotificationToChannelMembers
        }
        return channelAttributeOptions
    }
    
    func toSendMessageOptions() -> AgoraRtmSendMessageOptions {
        return AgoraRtmSendMessageOptions()
    }

    func toRtmServiceContext() -> AgoraRtmServiceContext {
        let context = AgoraRtmServiceContext()
        if let areaCode = self["areaCode"] as? UInt {
            context.areaCode = AgoraRtmAreaCode(rawValue: areaCode)
        }
        if let proxyType = self["proxyType"] as? UInt {
            context.proxyType = AgoraRtmCloudProxyType(rawValue: proxyType)
        }
        return context
    }

    func toMetadataItem() -> AgoraRtmMetadataItem {
        let metadataItem = AgoraRtmMetadataItem()
        if let key = self["key"] as? String {
            metadataItem.key = key
        }
        metadataItem.value = self["value"] as? String
        if let revision = self["revision"] as? Int64 {
            metadataItem.revision = revision
        }
        metadataItem.authorUserId = self["authorUserId"] as? String
        return metadataItem
    }

    func toMetadataOptions() -> AgoraRtmMetadataOptions {
        let metadataOptions = AgoraRtmMetadataOptions()
        if let majorRevision = self["majorRevision"] as? Int64 {
            metadataOptions.majorRevision = majorRevision
        }
        if let enableRecordTs = self["enableRecordTs"] as? Bool {
            metadataOptions.enableRecordTs = enableRecordTs
        }
        if let enableRecordUserId = self["enableRecordUserId"] as? Bool {
            metadataOptions.enableRecordUserId = enableRecordUserId
        }
        return metadataOptions
    }
}

extension Array {
    func toRtmAttributeList() -> [AgoraRtmAttribute] {
        return self.map { ($0 as? [String: Any?] ?? [:]).toRtmAttribute() }
    }
    
    func toRtmChannelAttributeList() -> [AgoraRtmChannelAttribute] {
        return self.map { ($0 as? [String: Any?] ?? [:]).toRtmChannelAttribute() }
    }

    func toMetadataItemList() -> [AgoraRtmMetadataItem] {
        return self.map { ($0 as? [String: Any?] ?? [:]).toMetadataItem() }
    }
    
    func toStringList() -> [String] {
        return self.map { $0 as? String ?? "" }
    }
    
    func toJson() -> [[String: Any?]] {
        return self.map {
            switch $0 {
            case let it as AgoraRtmAttribute: return it.toJson()
            case let it as AgoraRtmChannelAttribute: return it.toJson()
            case let it as AgoraRtmMember: return it.toJson()
            case let it as AgoraRtmChannelMemberCount: return it.toJson()
            case let it as AgoraRtmMetadataItem: return it.toJson()
            default: return [:]
            }
        }
    }
}
