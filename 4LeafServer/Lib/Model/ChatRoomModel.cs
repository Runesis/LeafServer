using System.Collections.Generic;

namespace LeafServer
{
    // TODO : 클라이언트 측, 채팅방 구현 이전에는 해당 클래스는 의미가 없음.
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

        public ChatRoomModel(int RoomIndex, string Title, string Password, int Roof, int Interior, int MaxCount, NTClient RoomOwner)
        {
            this.RoomIndex = RoomIndex;
            this.Title = Title;
            this.Password = Password;
            this.Roof = Roof;
            this.Interior = Interior;

            MaxUser = MaxCount;
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
