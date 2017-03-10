package grest.sheets.v4;

import grest.Authenticator;
import tink.http.Client;
import tink.web.proxy.Remote;
import tink.url.Host;

class Sheets {
	public static function api(auth:Authenticator) {
		return new Remote<grest.sheets.v4.api.Sheets>(new AuthedClient(auth, new SecureSocketClient()), new RemoteEndpoint(new Host('sheets.googleapis.com')));
		
	}
	
}
