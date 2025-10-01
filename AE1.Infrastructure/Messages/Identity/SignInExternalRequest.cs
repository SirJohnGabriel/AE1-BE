namespace AE1.Infrastructure.Messages.Identity
{
    using System.ComponentModel.DataAnnotations;
    using AE1.Infrastructure.Enums.Identity;

    public class SignInExternalRequest(CustomRole defaultRole, string idToken, string provider)
    {
        [Required]
        public string Provider { get; set; } = provider;

        [Required]
        public string IdToken { get; set; } = idToken;

        [Required]
        public CustomRole DefaultRole { get; set; } = defaultRole;
    }
}
