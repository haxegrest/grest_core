package grest;

using DateTools;

@:forward
abstract AccessToken(AccessTokenContents) from AccessTokenContents to AccessTokenContents {
	inline function new(data)
		this = data;
	
	public inline function expired() {
		return this.expiry.getTime() > Date.now().getTime() + 60000; // one minute buffer
	}
	
	@:from
	public static inline function fromResponse(v:TokenResponse)
		return new AccessToken({
			accessToken: v.access_token,
			expiry: Date.now().delta(v.expires_in * 1000),
		});
}

typedef AccessTokenContents = {
	accessToken:String,
	expiry:Date,
}

typedef TokenResponse = {
	access_token:String,
	token_type:String,
	expires_in:Int,
}