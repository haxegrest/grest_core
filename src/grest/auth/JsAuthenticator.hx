package grest.auth;

import grest.AccessToken;
import grest.Authenticator;
import haxe.Json;
import jsonwebtoken.crypto.*;
import jsonwebtoken.signer.*;
import tink.http.Fetch.*;
import tink.http.Header;
import tink.QueryString;

using DateTools;
using tink.CoreApi;

class JsAuthenticator implements Authenticator {
	
	var clientId:String;
	var accessToken:String;
	var promise:Promise<AccessToken>;
	
	public function new(clientId, accessToken) {
		this.clientId = clientId;
		this.accessToken = accessToken;
	}
	
	public static function start(clientId:String, redirectUrl:String, scopes:Array<String>) {
		var body = QueryString.build({
			client_id: clientId,
			redirect_uri: redirectUrl,
			response_type: 'token',
			scope: scopes.join(' '),
		});
		
		js.Browser.window.location.href = 'https://accounts.google.com/o/oauth2/v2/auth?$body';
	}
	
	public function auth():Promise<AccessToken> {
		if(promise == null) {
			promise = fetch('https://www.googleapis.com/oauth2/v3/tokeninfo?access_token=$accessToken').all()
				.next(function(res):TokenInfo return Json.parse(res.body.toString()))
				.next(function(info) {
					return
						if(info.error != null) {
							var err = new Error('Invalid Token: ${info.error}');
							verified = Some(Failure(err));
							err;
						} else if(info.aud != clientId) {
							var err = new Error('Expected aud to be $clientId but got ${info.aud}');
							verified = Some(Failure(err));
							err;
						} else {
							var token = {
								accessToken: accessToken,
								expiry: Date.now().delta(info.expires_in * 1000),
							};
							verified = Some(Success(token));
							token;
						}
				});
		}
		return promise;
	}
}

typedef TokenInfo = {
	?error:String,
	aud:String,
	user_id:String,
	scope:String,
	expires_in:Int,
}