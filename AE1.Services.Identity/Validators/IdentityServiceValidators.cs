namespace AE1.Services.Identity.Validators
{
    using AE1.Infrastructure.Messages.Identity;
    using FluentValidation;

    public sealed class IdentityServiceValidators
    {
        public IdentityServiceValidators(IValidator<SignUpRequest> signUpValidator, IValidator<SignInRequest> signInValidator)
        {
            this.SignUpValidator = signUpValidator;
            this.SignInValidator = signInValidator;
        }

        public IValidator<SignUpRequest> SignUpValidator { get; private set; }

        public IValidator<SignInRequest> SignInValidator { get; private set; }
    }
}