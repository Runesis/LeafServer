using Microsoft.AspNet.SignalR;
using Microsoft.AspNet.SignalR.Hubs;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace SignalR
{
    public class ChatHub : Hub
    {
        private static List<UserModel> ConnectedUsers = new List<UserModel>();
        private static List<RoomModel> Rooms = new List<RoomModel>();
        private static List<MessageModel> CurrentMessage = new List<MessageModel>();

        public ChatHub()
        {
            Rooms.Add(new RoomModel()
            {
                RoomId = 1000,
                IsLock = false,
                UserList = new List<UserModel>()
            });
        }

        public override Task OnConnected()
        {
            var user = ConnectedUsers.Find(r => r.IdentityName == Context.User.Identity.Name);
            if (user == null)
            {
                user = new UserModel()
                {
                    UserName = Context.QueryString["UserName"],
                    IdentityName = Context.User.Identity.Name,
                    Connection = new ConnectionModel()
                    {
                        ConnectionID = Context.ConnectionId
                    }
                };
                ConnectedUsers.Add(user);
            }
            else
            {
                // TODO : 기본 채팅 대기실 진입
                //Groups.Add(Context.ConnectionId, "");
            }
            return base.OnConnected();
        }

        public override Task OnDisconnected(bool stopCalled)
        {
            var user = ConnectedUsers.Find(r => r.IdentityName == Context.User.Identity.Name);
            if (user != null)
            {
                Clients.Group(user.RoomId.ToString()).broadcastMessage(user.UserName + " Disconnected.");

                Rooms.RemoveAll(r => r.UserList.Exists(z => z.IdentityName == user.IdentityName));
                ConnectedUsers.Remove(user);
            }

            return base.OnDisconnected(stopCalled);
        }

        public override Task OnReconnected()
        {
            return base.OnReconnected();
        }

        [HubMethodName("setUserName")]
        public void SetUserName(string UserName)
        {
            var user = ConnectedUsers.Find(r => r.IdentityName == Context.User.Identity.Name);
            if (user != null)
                user.UserName = UserName;
        }

        public async Task JoinRoom(string roomId)
        {
            if (ulong.TryParse(roomId, out ulong rID))
            {
                var room = Rooms.Find(r => r.RoomId == rID);
                if (room == null)
                {
                    room = new RoomModel()
                    {
                        RoomId = rID,
                        IsLock = false,
                        UserList = new List<UserModel>()
                    };

                    Rooms.Add(room);
                }

                await Groups.Add(Context.ConnectionId, roomId);

                var user = ConnectedUsers.Find(r => r.IdentityName == Context.User.Identity.Name);
                user.RoomId = rID;
                room.UserList.Add(user);

                Clients.Group(roomId).broadcastMessage(user.UserName + " joined.");
            }
        }

        public Task LeaveRoom(string roomId)
        {
            if (ulong.TryParse(roomId, out ulong rID))
            {
                var room = Rooms.Find(r => r.RoomId == rID);
                if (room != null)
                {
                    var user = ConnectedUsers.Find(r => r.IdentityName == Context.User.Identity.Name);
                    if (room.UserList.Remove(user))
                    {
                        return Groups.Remove(Context.ConnectionId, roomId);
                    }
                }
            }

            return null;
        }

        public Task Send(string message)
        {
            var user = ConnectedUsers.Find(r => r.IdentityName == Context.User.Identity.Name);

            if (user == null)
                return null;

            return Clients.Group(user.RoomId.ToString()).broadcastMessage(user.UserName, message);
        }

        public void SendAll(string message)
        {
            var user = ConnectedUsers.Find(r => r.IdentityName == Context.User.Identity.Name);

            if (user == null)
                return;

            Clients.All.broadcastMessage(user.UserName, message);
        }

        public void SendPrivateMessage(string toUserId, string message)
        {

            string fromUserId = Context.ConnectionId;

            var toUser = ConnectedUsers.FirstOrDefault(x => x.UserName == toUserId);
            var fromUser = ConnectedUsers.FirstOrDefault(x => x.UserName == fromUserId);

            if (toUser != null && fromUser != null)
            {
                // send to 
                Clients.Client(toUserId).sendPrivateMessage(fromUserId, fromUser.UserName, message);

                // send to caller user
                Clients.Caller.sendPrivateMessage(toUserId, fromUser.UserName, message);
            }
        }

        public void BroadCastMessage(String msgFrom, String msg, String GroupName)
        {
            var id = Context.ConnectionId;
            string[] Exceptional = new string[0];
            Clients.Group(GroupName, Exceptional).receiveMessage(msgFrom, msg, "");
        }
    }

    public class UserModel
    {
        [Key]
        public string IdentityName { get; set; }

        public string UserName { get; set; }

        public ConnectionModel Connection { get; set; }

        public UInt64 RoomId { get; set; }
    }

    public class RoomModel
    {
        [Key]
        public UInt64 RoomId { get; set; }

        public string Password { get; set; }

        public List<UserModel> UserList { get; set; }

        public bool IsLock { get; set; }
    }

    public class ConnectionModel
    {
        [Key]
        public string ConnectionID { get; set; }

        public string UserAgent { get; set; }

        public bool IsConnected { get; set; }
    }

    public class MessageModel
    {
        public string UserName { get; set; }
        public string Message { get; set; }
    }
}