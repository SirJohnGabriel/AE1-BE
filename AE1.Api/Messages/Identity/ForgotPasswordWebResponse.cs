namespace AE1.Api.Messages.Identity
{
    using System.Net;
    using System.Text.Json.Serialization;
    using AE1.Api.Common.Responses;
    using AE1.Infrastructure.Constants.Errors;

    public class ForgotPasswordWebResponse : WebResponse<string>
    {
        public ForgotPasswordWebResponse(string data, string errorCode, string message)
            : base(data, errorCode, message)
        {
        }

        [JsonIgnore]
        public override Dictionary<string, HttpStatusCode> ErrorCodes => new Dictionary<string, HttpStatusCode>()
        {
            { IdentityServiceErrorCodes.UserNotFound, HttpStatusCode.BadRequest },
            { IdentityServiceErrorCodes.SocialUserForgotPasswordError, HttpStatusCode.BadRequest },
            { IdentityServiceErrorCodes.InvalidToken, HttpStatusCode.BadRequest },
            { IdentityServiceErrorCodes.UnexpectedError, HttpStatusCode.BadRequest },
        };
    }
}
