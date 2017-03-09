package grest.sheets.v4;

import tink.http.Client;
import tink.web.proxy.Remote;
import tink.url.Host;

class Sheets {
	public static var instance(get, null):Remote<grest.sheets.v4.api.Sheets>;
	static function get_instance() {
		if(instance == null) {
			instance = new Remote<grest.sheets.v4.api.Sheets>(new SecureSocketClient(), new RemoteEndpoint(new Host('sheets.googleapis.com')));
		}
		return instance;
	}
	
}
