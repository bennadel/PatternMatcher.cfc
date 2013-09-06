component
	extends = "TestCase"
	output = false
	hint = "I test the Pattern Matcher component."
	{

	// Set up the serializer before all tests.
	public void function setup() {

		var newline = chr( 10 );

		savecontent variable="input" {
			writeOutput( "Sarah,212-555-0001,sarah@bennadel.com" & newline );
			writeOutput( "Joanna,212-555-0002,joanna@bennadel.com" & newline );
			writeOutput( "Kim,212-555-0003,kim@bennadel.com" & newline );
			writeOutput( "Libby,212-555-0004,libby@bennadel.com" & newline );
		}

	}


	// ---
	// TEST METHODS.
	// ---


	public void function testReplaceAll() {

		var matcher = new lib.PatternMatcher( "(?m)^[^,]+", input );

		var result = matcher.replaceAll( "xxxxx" );

		assert( arrayLen( reMatch( "(?m)^xxxxx", result ) ) == 4 );

	}


	public void function testReplaceAllQuoted() {

		var matcher = new lib.PatternMatcher( "(?m)^([^,]+)", input );

		var result = matcher.replaceAllQuoted( "$1" );

		assert( arrayLen( reMatch( "(?m)^\$1", result ) ) == 4 );

	}


	public void function testReplaceFirst() {

		var matcher = new lib.PatternMatcher( "(?m)^[^,]+", input );

		var result = matcher.replaceFirst( "xxxxx" );

		assert( arrayLen( reMatch( "(?m)^xxxxx", result ) ) == 1 );

	}


	public void function testReplaceFirstQuoted() {

		var matcher = new lib.PatternMatcher( "(?m)^([^,]+)", input );

		var result = matcher.replaceFirstQuoted( "$1" );

		assert( arrayLen( reMatch( "(?m)^\$1", result ) ) == 1 );

	}


	public void function testReplaceMatch() {

		var matcher = new lib.PatternMatcher( "(\d{3})-(?:\d{3})-(\d{4})", input );

		while ( matcher.findNextMatch() ) {

			matcher.replaceMatch( "$1-000-$2" );

		}

		var result = matcher.result();

		assert( reFind( "212-000-0001", result ) );
		assert( reFind( "212-000-0002", result ) );
		assert( reFind( "212-000-0003", result ) );
		assert( reFind( "212-000-0004", result ) );

	}


	public void function testReplaceMatchWithGroup() {

		var matcher = new lib.PatternMatcher( "(?m)^([^,]+)", input );

		while ( matcher.findNextMatch() ) {

			matcher.replaceMatch( ucase( matcher.group( 1 ) ) );

		}

		var result = matcher.result();

		assert( ! reFind( "Sarah", result ) );
		assert( ! reFind( "Joanna", result ) );
		assert( ! reFind( "Kim", result ) );
		assert( ! reFind( "Libby", result ) );

		assert( reFind( "SARAH", result ) );
		assert( reFind( "JOANNA", result ) );
		assert( reFind( "KIM", result ) );
		assert( reFind( "LIBBY", result ) );

	}


	public void function testMatch() {

		var matcher = new lib.PatternMatcher( "(?m)^([^,]+)", input );

		var matches = matcher.match();

		assert( arrayLen( matches ) == 4 );
		assert( matches[ 1 ] == "Sarah" );
		assert( matches[ 2 ] == "Joanna" );
		assert( matches[ 3 ] == "Kim" );
		assert( matches[ 4 ] == "Libby" );		

	}


	public void function testMatchGroups() {

		var matcher = new lib.PatternMatcher( "(?m)^([^,]+),([\d-]+),([^\n]+)", input );

		var matches = matcher.matchGroups();

		assert( arrayLen( matches ) == 4 );

		assert( matches[ 1 ][ 1 ] == "Sarah" );
		assert( matches[ 1 ][ 2 ] == "212-555-0001" );
		assert( matches[ 1 ][ 3 ] == "sarah@bennadel.com" );

		assert( matches[ 2 ][ 1 ] == "Joanna" );
		assert( matches[ 2 ][ 2 ] == "212-555-0002" );
		assert( matches[ 2 ][ 3 ] == "joanna@bennadel.com" );

		assert( matches[ 3 ][ 1 ] == "Kim" );
		assert( matches[ 3 ][ 2 ] == "212-555-0003" );
		assert( matches[ 3 ][ 3 ] == "kim@bennadel.com" );

		assert( matches[ 4 ][ 1 ] == "Libby" );
		assert( matches[ 4 ][ 2 ] == "212-555-0004" );
		assert( matches[ 4 ][ 3 ] == "libby@bennadel.com" );

	}


	// ---
	// PRIVATE METHODS.
	// ---

}