using System.Collections.Generic;

namespace LeafServer
{
    public class ChatRoomModel : DisposeClass
    {
        ~ChatRoomModel()
        { Dispose(); }

        public int RoomIndex { get; set; }
        public string Title { get; set; }
        public string Password { get; set; }
        public int MaxUser { get; set; }
        public int Roof { get; set; }
        public int Interior { get; set; }
        public string Owner { get; set; }
        public bool Lock { get; set; }

        public List<NTClient> UserList;

        public ChatRoomModel(int inRoomIndex, string inTitle, string inPassword, int inRoof, int inInterior, int inMaxCount, NTClient RoomOwner)
        {
            RoomIndex = inRoomIndex;
            Title = inTitle;
            Password = inPassword;

            Roof = inRoof;
            Interior = inInterior;
            MaxUser = inMaxCount;
            Lock = false;

            Owner = RoomOwner.UserInfo.AvatarList.Find(r => r.Order == RoomOwner.UserInfo.AvatarOrder).CharacterName;

            UserList = new List<NTClient> { RoomOwner };
        }

        public void SendUserList()
        { }

        public void SendChatMessage()
        { }
    }
}
