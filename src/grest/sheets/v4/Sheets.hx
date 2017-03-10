package grest.sheets.v4;

import grest.Authenticator;
import tink.http.Client;
import tink.web.proxy.Remote;
import tink.url.Host;
import tink.http.Client;
import tink.http.Request;
import tink.http.Response;
import tink.http.Header;

using tink.CoreApi;

class AuthedClient implements ClientObject {
	var auth:Authenticator;
	var proxy:Client;
	
	public function new (auth, proxy) {
		this.auth = auth;
		this.proxy = proxy;
	}
	
	public function request(req:OutgoingRequest):Future<IncomingResponse> {
		return auth.auth()
			.next(function(token) {
				req.header.fields.push(new HeaderField('authorization', 'Bearer ' + token.accessToken));
				return proxy.request(req);
			})
			.recover(IncomingResponse.reportError);
	}
}

class Sheets {
	public static function api(auth:Authenticator) {
		return new Remote<grest.sheets.v4.api.Sheets>(new AuthedClient(auth, new SecureSocketClient()), new RemoteEndpoint(new Host('sheets.googleapis.com')));
		
	}
	
}
