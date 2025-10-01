namespace AE1.Infrastructure.Services.Interfaces
{
    using System.Threading.Tasks;
    using AE1.Infrastructure.Messages;
    using AE1.Infrastructure.Messages.Identity;

    public interface IIdentityService
    {
        Task<Response> SignUpAsync(SignUpRequest request);

        Task<Response<string>> SignInAsync(SignInRequest request);

        Task<Response<string>> SignInExternalAsync(SignInExternalRequest request);

        Task<Response> AddToRoleAsync(AddToRoleRequest request);

        Task<Response<string>> ForgotPasswordAsync(ForgotPasswordRequest request);

        Task<Response> ResetPasswordAsync(ResetPasswordRequest request);
    }
}