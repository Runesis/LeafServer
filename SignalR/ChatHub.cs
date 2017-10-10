using Microsoft.AspNet.SignalR;
using Microsoft.AspNet.SignalR.Hubs;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
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
            var user = ConnectedUsers.Find(r => r.Connection.ConnectionID == Context.ConnectionId);
            if (user == null)
            {
                user = new UserModel()
                {
                    //UserName = Context.QueryString["UserName"],
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
            var user = ConnectedUsers.Find(r => r.Connection.ConnectionID == Context.ConnectionId);
            if (user != null)
            {
                Clients.Group(user.RoomId.ToString()).broadcastMessage(user.UserName + " Disconnected.");

                Rooms.RemoveAll(r => r != null && r.UserList.Exists(z => z.IdentityName == user.IdentityName));
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
            var user = ConnectedUsers.Find(r => r.Connection.ConnectionID == Context.ConnectionId);
            if (user != null)
                user.UserName = UserName;
        }

        public async Task JoinRoom(string roomId)
        {
            if (ulong.TryParse(roomId, out ulong rID))
            {
                var room = Rooms.Find(r => r.RoomId == rID);
                var user = ConnectedUsers.Find(r => r.Connection.ConnectionID == Context.ConnectionId);

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
                else
                    user.RoomId = rID;

                await Groups.Add(Context.ConnectionId, rID.ToString());

                user.RoomId = rID;
                room.UserList.Add(user);

                Clients.Group(roomId).broadcastMessage(user.UserName + " joined.");
            }
        }

        public Task LeaveRoom(string roomId)
        {
            var user = ConnectedUsers.Find(r => r.Connection.ConnectionID == Context.ConnectionId);

            if (string.IsNullOrEmpty(roomId))
                roomId = user.RoomId.ToString();

            if (ulong.TryParse(roomId, out ulong rID))
            {
                var room = Rooms.Find(r => r != null && r.RoomId == rID);
                if (room != null)
                {
                    if (room.UserList.Remove(user))
                    {
                        user.RoomId = 0;
                        Clients.Group(rID.ToString()).broadcastMessage(user.UserName + " leave room.");
                        return Groups.Remove(Context.ConnectionId, rID.ToString());
                    }

                    if (room.UserList.Count < 0)
                        Rooms.Remove(room);
                }
            }

            return null;
        }

        public Task Send(string message)
        {
            var user = ConnectedUsers.Find(r => r.Connection.ConnectionID == Context.ConnectionId);

            if (user == null || user.RoomId < 1)
                return null;

            return Clients.Group(user.RoomId.ToString()).broadcastMessage(user.UserName, message);
        }

        public void GlobalSendAll(string message)
        {
            var user = ConnectedUsers.Find(r => r.Connection.ConnectionID == Context.ConnectionId);

            if (user == null)
                return;

            Clients.All.globalBroadcast(user.UserName, message);
        }

        public void SendPrivateMessage(string toUserId, string message)
        {
            string fromUserId = Context.ConnectionId;

            var toUser = ConnectedUsers.Find(x => x.UserName == toUserId);
            var fromUser = ConnectedUsers.Find(x => x.Connection.ConnectionID == fromUserId);

            if (toUser != null && fromUser != null)
            {
                // send to 
                Clients.Client(toUser.Connection.ConnectionID).receivePrivateMessage(fromUser.UserName, message);

                // send to caller user
                Clients.Caller.sendPrivateMessage(toUser.UserName, message);
            }
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