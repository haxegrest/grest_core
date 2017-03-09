package grest.sheets.v4;

import tink.http.Client;
import tink.web.proxy.Remote;
import tink.url.Host;

class Sheets {
	public static var instance(get, null):Remote<Api>;
	static function get_instance() {
		if(instance == null) {
			instance = new Remote<Api>(new SecureSocketClient(), new RemoteEndpoint(new Host('sheets.googleapis.com')));
		}
		return instance;
	}
	
}

interface Api {
	@:sub('/v4/spreadsheets')
	var spreadsheets:Spreadsheets;
}