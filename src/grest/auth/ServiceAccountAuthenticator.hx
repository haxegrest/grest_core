package grest.auth;

import grest.AccessToken;
import grest.Authenticator;
import jsonwebtoken.crypto.*;
import jsonwebtoken.signer.*;
import tink.http.Fetch.*;
import tink.http.Header;
import tink.Json;
import tink.QueryString;

using tink.CoreApi;

class ServiceAccountAuthenticator implements Authenticator {
	
	var account:ServiceAccount;
	
	public function new(account) {
		this.account = account;
	}
	
	public function auth(scopes:Array<String>):Promise<AccessToken> {
		var signer = new BasicSigner(RS256({privateKey: account.private_key}));
		var payload:AuthClaims = {
			iss: account.client_email,
			scope: scopes.join(' '),
			aud: 'https://www.googleapis.com/oauth2/v4/token',
			exp: Std.int(Date.now().getTime() / 1000 + 3600),
			iat: Std.int(Date.now().getTime() / 1000),
		}
		return signer.sign(payload)
			.next(function(token) {
				var body = QueryString.build({
					grant_type: 'urn:ietf:params:oauth:grant-type:jwt-bearer',
					assertion: token,
				});
				return fetch('https://www.googleapis.com/oauth2/v4/token', {
					method: POST,
					headers: [
						new HeaderField(ContentType, 'application/x-www-form-urlencoded'),
						new HeaderField(ContentLength, Std.string(body.length)),
					],
					body: body,
				}).all();
			})
			.next(function(res) return Json.parse((res.body.toString():TokenResponse)))
			.next(AccessToken.fromResponse);
	}
}

typedef AuthClaims = {
	> jsonwebtoken.Claims,
	scope:String,
}

typedef ServiceAccount = {
	type:String,
	project_id:String,
	private_key_id:String,
	private_key:String,
	client_email:String,
	client_id:String,
	auth_uri:String,
	token_uri:String,
	auth_provider_x509_cert_url:String,
	client_x509_cert_url:String,
}
