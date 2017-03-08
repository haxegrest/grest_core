# Google REST API Client in Haxe

Experiment


#### Example

```haxe
public function bar() {
	return token()
		.next(function(token) return grest.sheets.v4.spreadsheets.Values.get(token, {
			path: {
				spreadsheetId: '1yy5i82f98V_SkAJdfnPylUrhadbdcJQ6GPtpsmR7aSWg',
				range: 'A1',
			},
			query: {},
		}))
		.handle(function(res) trace(res));
}

function token() {
	return authenticator().next(function(auth) return auth.auth(['https://www.googleapis.com/auth/spreadsheets']));
}

function authenticator():Promise<Authenticator> {
	return tink.Json.parse((File.getContent('./service-account.json'):ServiceAccount))
		.map(function(acc):Authenticator return new ServiceAccountAuthenticator(acc));
}
```