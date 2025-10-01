namespace AE1.Services.Identity.Extensions.Models
{
    using AE1.Infrastructure.Entities.Identity;
    using AE1.Infrastructure.Messages.Identity;

    public static class UserExtensions
    {
        public static User AsUser(this SignUpRequest request)
        {
            var result = new User
            {
                UserName = request.UserName,
                Email = request.UserName,
                FirstName = request.FirstName,
                LastName = request.LastName,
            };

            return result;
        }
    }
}
