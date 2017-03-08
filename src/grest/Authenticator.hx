package grest;

using tink.CoreApi;

interface Authenticator {
	function auth(scopes:Array<String>):Promise<AccessToken>;
}