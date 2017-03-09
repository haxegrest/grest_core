package grest.sheets.v4;

import grest.sheets.v4.types.*;

interface Spreadsheets {
	@:get('/$id')
	function get(id:String, query:{access_token:String}):Spreadsheet;
	
	@:post('/')
	function create(query:{access_token:String}, body:Spreadsheet):Spreadsheet;
}