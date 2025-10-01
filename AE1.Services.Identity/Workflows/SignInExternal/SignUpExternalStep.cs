namespace AE1.Services.Identity.Workflows.SignUpExternal
{
    using System.Threading.Tasks;
    using AE1.Infrastructure.Constants.Errors;
    using AE1.Infrastructure.Entities.Identity;
    using AE1.Infrastructure.Messages;
    using AE1.Infrastructure.Messages.Identity;
    using AE1.Infrastructure.Workflows;
    using AE1.Services.Identity.Extensions;
    using AE1.Services.Identity.Helpers;
    using AE1.Services.Identity.Workflows.SignInExternal;
    using AEA1.Services.Identity.Extensions;
    using Microsoft.AspNetCore.Identity;

    internal class SignUpExternalStep : AsyncStep<SignInExternalWorkflowRequest, Response<string>>
    {
        private readonly UserManager<User> userManager;

        private readonly RoleManager<Role> roleManager;

        private readonly JwtHelper jwtHelper;

        public SignUpExternalStep(UserManager<User> userManager, RoleManager<Role> roleManager, JwtHelper jwtHelper)
        {
            this.userManager = userManager;
            this.roleManager = roleManager;
            this.jwtHelper = jwtHelper;
        }

        public override async Task<Response<string>> ExecuteAsync(SignInExternalWorkflowRequest request)
        {
            var user = await this.userManager.FindByEmailAsync(request.Payload.Email);

            if (user == null)
            {
                user = new User { Email = request.Payload.Email, UserName = request.Payload.Email };
                await this.userManager.CreateAsync(user);
                await this.userManager.AddLoginAsync(user, request.UserLoginInfo);

                var defaultClaims = request.Payload.AsClaims(user.Id.ToString());
                await this.userManager.AddClaimsAsync(user, defaultClaims);
                await this.roleManager.AddToRoleAsync(this.userManager, new AddToRoleRequest(user.Id.ToString(), request.Request.DefaultRole.ToString()));

                request.User = user;
                request.Response.Data = await this.userManager.GenerateJwtAsync(this.jwtHelper, user);
                return request.Response;
            }
            else
            {
                request.Response.SetError(IdentityServiceErrorCodes.GoogleEmailAlreadyInUse);
                return request.Response;
            }
        }
    }
}