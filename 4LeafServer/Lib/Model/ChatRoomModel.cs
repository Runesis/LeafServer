using NSLib;
using System;
using System.Collections.Generic;

namespace LeafServer
{
    // TODO : 클라이언트 측, 채팅방 구현 이전에는 해당 클래스는 의미가 없음.
    public class ChatRoomModel : DisposeClass
    {
        public ChatRoomModel()
        {
            Lock = false;
        }

        ~ChatRoomModel()
        { Dispose(); }

        public byte RoomIndex { get; set; }
        public string Title { get; set; }
        public string Password { get; set; }
        public byte MaxUser { get; set; }
        public UInt16 Roof { get; set; }
        public UInt16 Interior { get; set; }
        public string Owner { get; set; }
        public bool Lock { get; set; }

        public List<NTClient> UserList;

        public ChatRoomModel(byte inRoomIndex, string inTitle, string inPassword, ushort inRoof, ushort inInterior, byte inMaxCount, NTClient inRoomOwner)
        {
            RoomIndex = inRoomIndex;
            Title = inTitle;
            Password = inPassword;
            Roof = inRoof;
            Interior = inInterior;
            MaxUser = inMaxCount;
            Owner = inRoomOwner.UserInfo.AvatarList.Find(r => r.Order == inRoomOwner.UserInfo.AvatarOrder).CharacterName;

            UserList = new List<NTClient> { inRoomOwner };
        }

        public void SendUserList()
        { }

        public void SendChatMessage()
        { }
    }
}
