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
	var scopes:Array<String>;
	var promise:Void->Promise<AccessToken>;
	
	public function new(account, scopes) {
		this.account = account;
		this.scopes = scopes;
	}
	
	public function auth():Promise<AccessToken> {
		if(promise == null) {
			var crypto = new DefaultCrypto();
			var signer = new BasicSigner(RS256({publicKey:null, privateKey: account.private_key}), crypto);
			
			promise = Promise.cache(function() {
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
								new HeaderField(CONTENT_TYPE, 'application/x-www-form-urlencoded'),
								new HeaderField(CONTENT_LENGTH, Std.string(body.length)),
							],
							body: body,
						}).all();
					})
					.next(function(res):TokenResponse return Json.parse(res.body.toString()))
					.next(AccessToken.fromResponse)
					.next(function(token) {
						var delay = Std.int(token.expiry.getTime() - Date.now().getTime());
						return new Pair(token, Future.async(function(cb) haxe.Timer.delay(cb.bind(Noise), delay)));
					});
			});
		}
		return promise();
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
