namespace AE1.Services.Identity.Workflows
{
    using AE1.Infrastructure.Entities.Identity;
    using AE1.Infrastructure.Messages;
    using AE1.Infrastructure.Workflows;
    using AE1.Services.Identity.Helpers;
    using AE1.Services.Identity.Workflows.SignInExternal;
    using AE1.Services.Identity.Workflows.SignUpExternal;
    using Microsoft.AspNetCore.Identity;

    public class IdentityServiceWorkflows
    {
        private readonly UserManager<User> userManager;

        private readonly RoleManager<Role> roleManager;

        private readonly JwtHelper jwtHelper;

        public IdentityServiceWorkflows(UserManager<User> userManager, RoleManager<Role> roleManager, JwtHelper jwtHelper)
        {
            this.userManager = userManager;
            this.roleManager = roleManager;
            this.jwtHelper = jwtHelper;
        }

        public virtual AsyncStep<SignInExternalWorkflowRequest, Response<string>> CreateSignInExternalWorkflow()
        {
            var result = new ValidateExternalTokenStep(this.jwtHelper);
            result.SetNextStep(new TrySignInExternalStep(this.userManager, this.jwtHelper));
            result.SetNextStep(new SignUpExternalStep(this.userManager, this.roleManager, this.jwtHelper));

            return result;
        }
    }
}