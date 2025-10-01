namespace AE1.Api.Extensions.Injection
{
    using AE1.Infrastructure.Logging;
    using AE1.Infrastructure.Settings;

    public static class Infrastructure
    {
        public static void InjectInfrastructure(this IServiceCollection services, IConfiguration config, WebApplicationBuilder builder)
        {
            var aiConnectionString = config.GetConnectionString("APPLICATIONINSIGHTS_CONNECTION_STRING");

            if (!string.IsNullOrEmpty(aiConnectionString))
            {
                // Use Application Insights if configured
                services.AddSingleton(typeof(ILogger), instance => new InsightsLogger(aiConnectionString));
            }
            else
            {
                // Use console logger for development/local environments
                services.AddSingleton<ILogger, ConsoleLogger>();
            }

            services.Configure<JwtSettings>(config.GetSection("Jwt"));
        }
    }
}