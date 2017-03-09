package grest;

import tink.http.Fetch.fetch;
import tink.http.Header;
import tink.http.Method;
using tink.CoreApi;

@:autoBuild(grest.macro.ApiBuilder.build())
class Api {
	
	function __call<T>(options:{
		token:AccessToken,
		path:String,
		query:String,
		?method:Method,
		?body:String,
		?headers:Array<HeaderField>,
	}):Promise<T> {
		var url = options.path;
		if(options.query != null) url += '?' + options.query;
		
		var headers = [
			new HeaderField(Accept, 'application/json'),
			new HeaderField('authorization', 'Bearer ${options.token.accessToken}'),
		];
		
		if(options.body != null) {
			headers.push(new HeaderField(ContentType, 'application/json'));
			headers.push(new HeaderField(ContentLength, Std.string(options.body.length)));
		}
		
		return fetch(url, {
			method: options.method,
			headers: headers,
			body: options.body,
		}).all().next(function(res):T return haxe.Json.parse(res.body.toString()));
	}
}