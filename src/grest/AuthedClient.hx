package grest;

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
				return req.body.all();
			})
			.next(function(bytes) { // TODO: tink_web should do this...
				req.header.fields.push(new HeaderField(ContentLength, Std.string(bytes.length)));
				@:privateAccess req.body = bytes;
				return proxy.request(req);
			})
			.recover(IncomingResponse.reportError);
	}
}