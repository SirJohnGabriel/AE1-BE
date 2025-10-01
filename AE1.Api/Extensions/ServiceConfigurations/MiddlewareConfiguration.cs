namespace AE1.Api.Extensions.ServiceConfigurations
{
    using AE1.Api.Filters;

    public static class MiddlewareConfiguration
    {
        public static void RegisterMiddlewares(this IServiceCollection services)
        {
            services.AddControllers(options =>
            {
                options.Filters.Add<HandleExceptionAttribute>();
            });

            services.AddOpenApi();
        }
    }
}