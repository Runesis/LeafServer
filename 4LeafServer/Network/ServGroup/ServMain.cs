using System;

namespace _4LeafServer
{
    public class ServMain : IDisposable
    {
        public ServMain()
        { }

        ~ServMain()
        { Dispose(false); }

        public void Dispose()
        {
            Dispose(true);

            GC.SuppressFinalize(this);
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

            // unmanaged resource
            // disposed

            _alreadyDisposed = true;
        }
    }
}