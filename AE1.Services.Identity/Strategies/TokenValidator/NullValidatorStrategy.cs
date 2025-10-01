namespace AE1.Services.Identity.Strategies.TokenValidator
{
    using AE1.Services.Identity.Models;

    public class NullValidatorStrategy : ITokenValidatorStrategy
    {
        public TokenPayload ValidateToken(string idToken)
        {
            return new TokenPayload();
        }
    }
}
