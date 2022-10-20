local claims = {
  email_verified: false
} + std.extVar('claims');

{
  identity: {
    traits: {
      // Allowing unverified email addresses enables account
      // enumeration attacks, especially if the value is used for
      // e.g. verification or as a password login identifier.
      //
      // Therefore we only return the email if it (a) exists and (b) is marked verified
      // by GitHub.
      [if "email" in claims && claims.email_verified then "email" else null]: claims.email,
      [if "nickname" in claims then "username" else null]: claims.nickname,
      [if "nickname" in claims then "github_username" else null]: claims.nickname,
      [if "name" in claims then "full_name" else null]: claims.name,
      [if "picture" in claims then "picture" else null]: claims.picture,
    },
  },
}
