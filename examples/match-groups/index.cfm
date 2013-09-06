<cfscript>
	
	savecontent variable="input" {
		writeOutput( "Sarah,212-555-0001,sarah@bennadel.com" & chr( 10 ) );
		writeOutput( "Joanna,212-555-0002,joanna@bennadel.com" & chr( 10 ) );
		writeOutput( "Kim,212-555-0003,kim@bennadel.com" & chr( 10 ) );
		writeOutput( "Libby,212-555-0004,libby@bennadel.com" & chr( 10 ) );
	}

	// Match each item within each line of the input data.
	matcher = new lib.PatternMatcher( "(?m)([^,]+),([^,]+),([^,\n]+)", input );

	writeDump( matcher.matchGroups() );

</cfscript>
