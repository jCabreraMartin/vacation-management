using System.Net;

namespace VacationManagement.Api;

public static class LocalOnlyAccess
{
    public static void ConfigureListeners(WebApplicationBuilder builder)
    {
        ArgumentNullException.ThrowIfNull(builder);
        var urls = (builder.Configuration["urls"] ?? "http://localhost:5080").Split(';', StringSplitOptions.RemoveEmptyEntries);
        if (urls.Length == 0 || builder.Configuration.GetSection("Kestrel:Endpoints").GetChildren().Any())
        {
            throw new InvalidOperationException("Configure loopback listeners using --urls only.");
        }

        var addresses = urls.Select(url =>
        {
            if (!Uri.TryCreate(url, UriKind.Absolute, out var address) || address.Scheme != "http" ||
                !IsLoopbackHost(address.Host) || address.AbsolutePath != "/" || address.Query.Length != 0 || address.UserInfo.Length != 0)
            {
                throw new InvalidOperationException("Only HTTP loopback listeners are permitted for this laboratory.");
            }

            return address;
        }).ToArray();

        builder.WebHost.ConfigureKestrel(options =>
        {
            options.Configure(new ConfigurationBuilder().Build(), reloadOnChange: false);
            foreach (var address in addresses)
            {
                if (address.Host.Equals("localhost", StringComparison.OrdinalIgnoreCase))
                {
                    options.ListenLocalhost(address.Port);
                }
                else
                {
                    options.Listen(IPAddress.Parse(address.Host.Trim('[', ']')), address.Port);
                }
            }
        });
    }

    public static IApplicationBuilder UseLocalOnlyAccess(this IApplicationBuilder app)
    {
        ArgumentNullException.ThrowIfNull(app);
        return app.Use(async (context, next) =>
        {
            var request = context.Request;
            var writes = !HttpMethods.IsGet(request.Method) && !HttpMethods.IsHead(request.Method) && !HttpMethods.IsOptions(request.Method);
            var origin = request.Headers.Origin.ToString();
            var trustedOrigin = origin.Length == 0 ||
                origin.Equals($"{request.Scheme}://{request.Host}", StringComparison.OrdinalIgnoreCase) ||
                origin is "http://localhost:5173" or "http://127.0.0.1:5173" or "http://[::1]:5173";

            if (!IsLoopbackHost(request.Host.Host) || (writes && (request.Headers["X-Laboratory-Request"] != "1" || !trustedOrigin)))
            {
                await Results.Problem(statusCode: StatusCodes.Status403Forbidden, title: "Local laboratory request required")
                    .ExecuteAsync(context).ConfigureAwait(false);
                return;
            }

            await next(context).ConfigureAwait(false);
        });
    }

    private static bool IsLoopbackHost(string host) =>
        host.Equals("localhost", StringComparison.OrdinalIgnoreCase) ||
        (IPAddress.TryParse(host.Trim('[', ']'), out var address) && IPAddress.IsLoopback(address));
}