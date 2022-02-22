# Authentication

## Configuration

### OpenID Connect (OIDC) Client Library

The authentication in the project relies on the oidc-client library. This library provides protocol support for OIDC, OAuth2.0 and functions for user session and access token management.

[OIDC-Client Documentation](https://github.com/IdentityModel/oidc-client-js/wiki)

### The UserManager Object

The UserManager object is used to configure and interact with the Identity Provider (IDP). All configurations and interactions involving the UserManager are handled via NgRx effects in the [auth.effects.ts](../libs/shared/auth/src/lib/+state/effects/auth.effects.ts) file.

The following configurations are present on the UserManager object:

- **authority:** The URL of the OIDC provider
- **client_id:** The identifier affiliated with this client application, registered with the OIDC provider
- **scope:** The scope being requested from the OIDC provider
- **response_type:** The type of response desired from the OIDC provider
- **redirect_uri:** The redirect URI of this client application to recieve a response from the OIDC provider
- **post_logout_redirect_uri:** The redirect URI of this client application to handle OIDC provider logout actions
- **silent_redirect_uri:** The redirect URI for the page in this client application that handles background token renewal tasks
- **automaticSilentRenewal:** Flag to indicate that there should be an automatic attempt to renew access tokens prior to their expiration

## Authentication Flow

### Guarding Routes & Authenticating

User authentication status in the NgRx store is automatically checked when they navigate to different pages of the client application. This is facilitated through an [authentication route guard](../libs/shared/core-http/src/lib/guards/auth.guard.ts).

When users have previously authenticated, their information is stored in the browser's session storage. The guard automatically checks for this information and either grants access to the requested URL or navigates the user away from the application to the IDP login page.

When the user is not recognized as authenticated via NgRx state, the guard collects the root path and parameters of the requested URL and stores them in the session storage. This is later retrieved so after authentication the user lands on the page they were originally wanting to view.

The guard dispatches the **CHECK FOR USER** action to the NgRx store. Through an effect, the UserManager attempts to retrieve the stored user information from session storage. If user information is retrieved, the **LOGIN SUCCESS** action is dispatched and the state updated to reflect valid authentication. If no information is retrieved, the **LOGIN START** action is dispatched to trigger the UserManager's signInRedirect() method which redirects the user to the IDP login page.

From the IDP login page, the user is prompted to authenticate via either username and password or through Azure Active Directory.

### Sign-In Redirect

When the user has successfully authenticated, the IDP redirects to the application via the signin_redirect_uri configuration. This is configured on both the client and server side. **THESE CONFIGURATIONS MUST MATCH**

The [SignInCallback component](../libs/shared/auth/src/lib/components/sign-in-callback/sign-in-callback.component.ts) is loaded upon redirect to the signin_redirect_uri. This component dispatches the **LOGIN FINISH** action to the store with the 'silent' flag set to false.

A false 'silent' flag triggers the UserManager's signinRedirectCallback() method. This method facilitates storing the authenticated user's information in session storage. **LOGIN SUCCESS** is then dispatched and state is updated with the user's information.

### Sign-Out Redirect

When the user logs out, the **LOGOUT START** action is dispatched and the UserManager's signoutRedirect() method is triggered. The user is then redirected to the IDP's logout uri and the logout process begins.

After the IDP handles the logout request, the user is redirected to the [SignOutCallback component]('../libs/shared/auth/src/lib/components/sign-out-callback/sign-out-callback.component.ts).

The component dispatches the **LOGOUT FINISH** action to the store and triggers the UserManager's signoutRedirectCallback() method. This method handles client-side user information cleanup and removes the user information from the browser's session storage.

After cleanup, the **LOGOUT SUCCESS** action is dispatched and the user information is removed from NgRx state

## Making Secure Requests

API requests require valid access tokens to be included in HTTP request headers. When requests are made, this is automatically handled by the [Auth Interceptor](../libs/shared/core-http/src/lib/interceptors/auth/auth.interceptor.ts).

The interceptor retrieves the value of the user's access token from the NgRx store and attaches it to the outgoing request header in the following format:

```
{
  Authorization: Bearer {access_token}
}
```

## Token Renewal

Token renewals are handled silently by the UserManager signinSilentCallback() method

By default, access token expire in 30 minutes. This is configured on the server side.
