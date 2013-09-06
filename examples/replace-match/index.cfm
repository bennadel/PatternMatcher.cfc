<cfscript>
	
	savecontent variable="input" {
		writeOutput( "Sarah,212-555-0001,sarah@bennadel.com" & chr( 10 ) );
		writeOutput( "Joanna,212-555-0002,joanna@bennadel.com" & chr( 10 ) );
		writeOutput( "Kim,212-555-0003,kim@bennadel.com" & chr( 10 ) );
		writeOutput( "Libby,212-555-0004,libby@bennadel.com" & chr( 10 ) );
	}

	// Find the email addresses so we can "*"-out the domain portion. Notice that we have
	// two capturing groups in the following pattern:
	// 1 : the user + "@".
	// 2 : the domain.
	matcher = new lib.PatternMatcher( "(?<=,)([^@]+@)([^\n]+)", input );

	// Find each email individually.
	while ( matcher.findNextMatch() ) {

		matcher.replaceMatch(
			"$1" & 
			repeatString( "*", len( matcher.group( 2 ) ) )
		);

	}

	writeOutput( "<pre>#matcher.result()#</pre>" );

</cfscript>
