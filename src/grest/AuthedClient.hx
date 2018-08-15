package grest;

import tink.http.Client;
import tink.http.Request;
import tink.http.Response;
import tink.http.Header;

using tink.io.Source;
using tink.CoreApi;

class AuthedClient implements ClientObject {
	var auth:Authenticator;
	var proxy:Client;
	var mode:Mode;
	
	public function new (auth, proxy, mode) {
		this.auth = auth;
		this.proxy = proxy;
		this.mode = mode;
	}
	
	public function request(req:OutgoingRequest):Promise<IncomingResponse> {
		return auth.auth()
			.next(function(token) {
				req = switch mode {
					case Header:
						new OutgoingRequest(
							req.header.concat([new HeaderField('authorization', 'Bearer ' + token.accessToken)]),
							req.body
						);
					case Query:
						var url = req.header.url + (switch req.header.url.query {
							case null | '': '?';
							default: '&';
						}) + 'access_token=${token.accessToken}';
						new OutgoingRequest(
							new OutgoingRequestHeader(req.header.method, url, req.header.protocol, [for(h in req.header) h]),
							req.body
						);
				}
				return proxy.request(req);
			});
	}
}

enum Mode {
	Header;
	Query;
}