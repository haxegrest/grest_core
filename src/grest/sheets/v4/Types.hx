package grest.sheets.v4;

typedef UpdateValuesResponse = {
	spreadsheetId:String,
	updatedRange:String,
	updatedRows:Int,
	updatedColumns:Int,
	updatedCells:Int,
	updatedData:ValueRange,
}

typedef ValueRange = {
	range:String,
	majorDimension:Dimension,
	values:Array<ListValue>,
}

typedef ListValue = Array<Dynamic>;

@:enum
abstract Dimension(String) from String to String to tink.Stringly {
	var DIMENSION_UNSPECIFIED = 'DIMENSION_UNSPECIFIED';
	var ROWS = 'ROWS';
	var COLUMNS = 'COLUMNS';
}

@:enum
abstract ValueInputOption(String) from String to String to tink.Stringly {
	var INPUT_VALUE_OPTION_UNSPECIFIED = 'INPUT_VALUE_OPTION_UNSPECIFIED';
	var RAW = 'RAW';
	var USER_ENTERED = 'USER_ENTERED';
}

@:enum
abstract ValueRenderOption(String) from String to String to tink.Stringly {
	var FORMATTED_VALUE = 'FORMATTED_VALUE';
	var UNFORMATTED_VALUE = 'UNFORMATTED_VALUE';
	var FORMULA = 'FORMULA';
}

@:enum
abstract DateTimeRenderOption(String) from String to String to tink.Stringly {
	var SERIAL_NUMBER = 'SERIAL_NUMBER';
	var FORMATTED_STRING = 'FORMATTED_STRING';
}