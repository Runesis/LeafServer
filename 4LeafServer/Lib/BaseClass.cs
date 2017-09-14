using System;

namespace _4LeafServer
{
    public class BaseClass : IDisposable
    {
        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        protected virtual void Dispose(bool disposing)
        {
            if (disposing)
            {
                // Free other state (managed objects).
            }
            // Free your own state (unmanaged objects).
            // Set large fields to null.
        }

        // Use C# destructor syntax for finalization code.
        ~BaseClass()
        {
            // Simply call Dispose(false).
            Dispose(false);
        }
    }
}
