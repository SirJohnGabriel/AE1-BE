namespace AE1.Api.Extensions.Validations
{
    using AE1.Infrastructure.Validations;

    public static class ValidationExtension
    {
        public static void RegisterValidators(this IServiceCollection services)
        {
            services.AddTransient<Validator>();
        }
    }
}