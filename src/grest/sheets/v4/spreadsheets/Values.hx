package grest.sheets.v4.spreadsheets;

import grest.sheets.v4.types.*;
import grest.Gateway.*;
import tink.http.Fetch.fetch;
import tink.http.Header;

using tink.CoreApi;

class Values {
	public static function append(token:AccessToken, options:{
		path:{
			spreadsheetId:String,
			range:String,
		},
		query:{
			valueInputOption:ValueInputOption,
			?insertDataOption:InsertDataOption,
			?includeValuesInResponse:Bool,
			?responseValueRenderOption:ValueRenderOption,
			?responseDateTimeRenderOption:DateTimeRenderOption,
		},
		body:ValueRange
	}):Promise<ValueRange> {
		return call({
			token: token,
			method: POST,
			path: 'https://sheets.googleapis.com/v4/spreadsheets/${options.path.spreadsheetId}/values/${options.path.range}:append',
			query: tink.QueryString.build(options.query),
			body: tink.Json.stringify(options.body),
		});
	}
	
	public static function get(token:AccessToken, options:{
		path:{
			spreadsheetId:String,
			range:String,
		},
		query:{
			?majorDimension:Dimension,
			?valueRenderOption:ValueRenderOption,
			?dateTimeRenderOption:DateTimeRenderOption,
		},
	}):Promise<ValueRange> {
		return call({
			token: token,
			path: 'https://sheets.googleapis.com/v4/spreadsheets/${options.path.spreadsheetId}/values/${options.path.range}',
			query: tink.QueryString.build(options.query),
		});
	}
	public static function update(token:AccessToken, options:{
		path:{
			spreadsheetId:String,
			range:String,
		},
		query:{
			valueInputOption:ValueInputOption,
			?includeValuesInResponse:Bool,
			?responseValueRenderOption:ValueRenderOption,
			?responseDateTimeRenderOption:DateTimeRenderOption,
		},
		body:ValueRange,
	}):Promise<UpdateValuesResponse> {
		return call({
			token: token,
			method: PUT,
			path: 'https://sheets.googleapis.com/v4/spreadsheets/${options.path.spreadsheetId}/values/${options.path.range}',
			query: tink.QueryString.build(options.query),
			body: tink.Json.stringify(options.body),
		});
	}
	
}