namespace AE1.Services.Identity.Strategies.TokenValidator
{
    using AE1.Services.Identity.Models;

    public interface ITokenValidatorStrategy
    {
        TokenPayload ValidateToken(string idToken);
    }
}
