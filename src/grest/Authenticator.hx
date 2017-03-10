package grest;

using tink.CoreApi;

interface Authenticator {
	function auth():Promise<AccessToken>;
}