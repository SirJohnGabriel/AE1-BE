namespace AE1.Services.Identity.Validators.SignIn
{
    using AE1.Infrastructure.Messages.Identity;
    using FluentValidation;
    using FluentValidation.Validators;

    public class SignInValidator : AbstractValidator<SignInRequest>
    {
        public SignInValidator()
        {
            this.RuleFor(req => req.UserName).NotEmpty();
            this.RuleFor(req => req.UserName).EmailAddress(EmailValidationMode.AspNetCoreCompatible);
            this.RuleFor(req => req.Password).NotEmpty();
        }
    }
}
