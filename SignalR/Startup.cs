using Microsoft.AspNet.SignalR;
using Microsoft.Owin;
using Owin;

[assembly: OwinStartup(typeof(SignalR.Startup))]

namespace SignalR
{
    public class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            // For more information on how to configure your application, visit https://go.microsoft.com/fwlink/?LinkID=316888
            var hubConfiguration = new HubConfiguration()
            {
                EnableDetailedErrors = true,
                //EnableJavaScriptProxies = false
            };
            app.MapSignalR(hubConfiguration);
        }
    }
}
