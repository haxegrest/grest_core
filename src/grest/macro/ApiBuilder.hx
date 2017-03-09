package grest.macro;

import haxe.macro.Context;
import haxe.macro.Expr;

class ApiBuilder {
	public static function build() {
		var fields = Context.getBuildFields();
		
		for(field in fields) {
			field.
		}
	}
}