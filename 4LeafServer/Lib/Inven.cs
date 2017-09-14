using System;

namespace _4LeafServer
{
    public class Inven : IDisposable
    {
        ~Inven()
        { Dispose(false); }

        public void Dispose()
        {
            try
            {
                Dispose(true);

                GC.SuppressFinalize(this);
            }
            catch
            { throw; }
        }
        private bool _alreadyDisposed = false;
        protected virtual void Dispose(bool inDisposing)
        {
            if (_alreadyDisposed == true)
            {
                return;
            }

            if (inDisposing == true)
            {
                // managed resource
            }

            _alreadyDisposed = true;
        }

        public ulong AccountID { get; set; }
        public ulong UID { get; set; }
        public int TID { get; set; }
        public int Type { get; set; }
    }
}
