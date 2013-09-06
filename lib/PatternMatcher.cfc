component
	output = false
	hint = "I provide easier, implicitly type-casted access to the underlying Java Pattern and Matcher functionality."
	{


	// Return the initialized component.
	public any function init(
		required string pattern,
		required string input
		) {

		// Store properties for reference.
		variables.pattern = pattern;
		variables.input = input;

		matcher = createMatcher( pattern, input );

		// A string buffer is used to hold the running-result for per-match replacement actions.
		buffer = createStringBuffer();
		
		return( this );

	}


	// ---
	// PUBLIC METHODS.
	// ---


	// I find the next pattern match within the input; returns True if a match was located.
	public boolean function findNextMatch() {

		return( matcher.find() );

	}


	// I return the value captured by the given group. If NOTE: Zero (0) will return the 
	// contents of the entire matched value. If the given group was not matched, the empty
	// string will be returned.
	public any function group( numeric index = 0 ) {

		var groupValue = matcher.group( javaCast( "int", index ) );

		// Since a group may not have actually been captured, check to make sure the local
		// variable has not been destroyed (via NULL return).
		if ( structKeyExists( local, "groupValue" ) ) {

			return( groupValue );

		}

		return( "" );

	}


	// I return the number of captured groups with the regular expression pattern.
	public numeric function groupCount() {

		return( matcher.groupCount() );

	}


	// I return a struct containing each group, keyed by index (starting with Zero). If a 
	// group was not captured, it will be set as the empty string.
	public struct function groups() {

		var currentMatch = {};
		var currentGroupCount = groupCount();

		// Start from zero - contains entire match.
		for ( var i = 0 ; i <= currentGroupCount ; i++ ) {

			currentMatch[ i ] = group( i );

		}

		return( currentMatch );

	}


	// I determine whether or not the given group was captured in the previous match.
	public boolean function hasGroup( required numeric index ) {

		var groupValue = matcher.group( javaCast( "int", index ) );

		return( structKeyExists( local, "groupValue" ) );

	}


	// I return the collection of all pattern matches found within the given input.
	// --
	// NOTE: This resets the internal matcher.
	public array function match() {

		reset();

		var matches = [];

		while ( findNextMatch() ) {

			arrayAppend( matches, group() );

		}

		return( matches );

	}


	// I return the collection of all pattern matches found within the given input, broken 
	// down by group.
	// --
	// NOTE: This resets the internal matcher.
	public array function matchGroups() {

		reset();

		var matches = [];

		while ( findNextMatch() ) {

			arrayAppend( matches, groups() );

		}

		return( matches );

	}


	// I escape special characters (such as back-refrences) in the given replacement such
	// that it can be used in a replace-action as a literal value.
	public string function quoteReplacement( required string replacement ) {

		return(
			matcher.quoteReplacement( javaCast( "string", replacement ) )
		);

	}


	// I replace all matches with the given replacement and returns the resultant string.
	// Back references within the replacement string will be honored unless the replacement 
	// value is quoted.
	public string function replaceAll( required string replacement ) {

		return(
			matcher.replaceAll( javaCast( "string", replacement ) )
		);

	}


	// I quote the replacement value (escaping back references) and then implicitly call
	// the replaceAll() function.
	public string function replaceAllQuoted( required string replacement ) {

		return(
			replaceAll( quoteReplacement( replacement ) )
		);

	}


	// I replace the first match with the given replacement and returns the resultant
	// string. Back references within the replacement string will be honored unless the
	// replacement value is quoted.
	public string function replaceFirst( required string replacement ) {

		return(
			matcher.replaceFirst( javaCast( "string", replacement ) )
		);

	}


	// I quote the replacement value (escaping back references) and then implicitly call
	// the replaceFirst() function.
	public string function replaceFirstQuoted( required string replacement ) {

		return(
			replaceFirst( quoteReplacement( replacement ) )
		);

	}


	// I replace the current match with the given value. Back references within the 
	// replacement string will be honored unless the replacement value is quoted.
	public any function replaceMatch( required string replacement ) {

		matcher.appendReplacement( buffer, javaCast( "string", replacement ) );

		return( this );

	}


	// I quote the replacement value (escaping back references) and then implicitly call
	// the replaceMatch() function.
	public any function replaceMatchQuoted( required string replacement ) {

		return(
			replaceMatch( quoteReplacement( replacement ) )
		);

	}


	// I reset the pattern matcher (with optional string - uses original input if omitted).
	public any function reset( string newInput = input ) {

		input = newInput;

		matcher.reset( javaCast( "string", input ) );

		buffer = createStringBuffer();

		return( this );

	}

	
	// I return the result of the replacement up until this point.
	public string function result() {

		// Since we are no longer dealing with replacements, append the rest of the
		// unmatched input string to the results buffer.
		matcher.appendTail( buffer );

		return( buffer.toString() );

	}


	// ---
	// PRIVATE METHODS.
	// ---


	// I create the given Matcher Java object using the given regular expression pattern
	// and input.
	private any function createMatcher(
		required string pattern,
		required string input
		) {

		return(
			createObject( "java", "java.util.regex.Pattern" )
				.compile( javaCast( "string", pattern ) )
				.matcher( javaCast( "string", input ) )
		);

	}


	// I create a Java string buffer.
	private any function createStringBuffer() {

		return(
			createObject( "java", "java.lang.StringBuffer" ).init()
		);

	}

}