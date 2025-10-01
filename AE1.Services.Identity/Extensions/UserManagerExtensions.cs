namespace AE1.Services.Identity.Extensions
{
    using System.Threading.Tasks;
    using AE1.Infrastructure.Entities.Identity;
    using AE1.Services.Identity.Helpers;
    using Microsoft.AspNetCore.Identity;

    internal static class UserManagerExtensions
    {
        public static async Task<string> GenerateJwtAsync(this UserManager<User> userManager, JwtHelper jwtHelper, User user)
        {
            var claims = await userManager.GetClaimsAsync(user);
            var result = jwtHelper.GenerateToken(claims);
            return result;
        }
    }
}