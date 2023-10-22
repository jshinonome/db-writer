.cli.Symbol[`hdbPath;`;"upsert hdb path"];
.cli.Symbol[`gzFilepath;`;"filepath"];
.cli.Symbol[`table;`;"table name"];

.z.zd:17 2 6;

.pipe.quote.columns:(!) . flip (
  (`time                         ;"N"); / "N"
  (`Exchange                     ;" "); / "C"
  (`sym                          ;"*"); / "*"
  (`BidPrice                     ;" "); / "E"
  (`BidSize                      ;" "); / "I"
  (`OfferPrice                   ;" "); / "E"
  (`OfferSize                    ;" "); / "I"
  (`QuoteCondition               ;" "); / "C"
  (`SequenceNumber               ;" "); / "I"
  (`NationalBBOInd               ;" "); / "C"
  (`FINRABBOIndicator            ;" "); / "C"
  (`FINRAADFMPIDIndicator        ;" "); / "H"
  (`QuoteCancelCorrection        ;" "); / "C"
  (`SourceOfQuote                ;" "); / "C"
  (`bidCond                      ;"C"); / "C"
  (`bidEx                        ;"C"); / "C"
  (`bid                          ;"E"); / "E"
  (`bidSize                      ;"I"); / "I"
  (`bidFINRAMarketMakerID        ;" "); / "*"
  (`askCond                      ;"C"); / "C"
  (`askEx                        ;"C"); / "C"
  (`ask                          ;"E"); / "F"
  (`askSize                      ;"I"); / "I"
  (`askFINRAMarketMakerID        ;" "); / "*"
  (`LULDIndicator                ;" "); / "C"
  (`LULDNBBOIndicator            ;" "); / "C"
  (`SIPGeneratedMessageIdentifier;" "); / "C"
  (`ParticipantTimestamp         ;" "); / "N"
  (`FINRAADFTimestamp            ;" "); / "N"
  (`SecurityStatusIndicator      ;" ") / "C"
 );

.pipe.quote.load:{
  table:flip (where .pipe.quote.columns <> " ")!(value .pipe.quote.columns;"|") 0: x;
  .log.Info ("upserting";count table;"to";string .pipe.parPath);
  upsert[.pipe.parPath] table
 };

.pipe.quote.post:{
  / cast Symbol column to symbol type and enumerate it
  symColPath:.Q.dd[.pipe.parPath;`sym];
  symFilePath:.Q.dd[.pipe.hdbPath;`sym];
  .log.Info ("enumerating and applying p attribute";symColPath);
  symValue:`p# symFilePath?`$get symColPath;
  symColPath set symValue;
  .log.Info ("finished enumerating and applying p attribute");
  / remove first line and last line
 };

.cli.Args:.cli.Parse[];

.pipe.hdbPath:hsym .cli.Args `hdbPath;

if[11h=not type key .pipe.hdbPath;
  .log.Error(.pipe.hdbPath;"not found or not a directory - ", string .pipe.hdbPath);
  exit 1
 ];

.pipe.parPath:.Q.dd[.Q.par[.pipe.hdbPath;"D"$-3_-11#string .cli.Args[`gzFilepath];.cli.Args`table];`];

.log.Info ("loading file";string .cli.Args `gzFilepath;"to";string .cli.Args `hdbPath);

.log.Info ("partition";.pipe.parPath);

if[`quote=.cli.Args`table;
  .pipe.startTime:.z.P;
  // use 5MB memory
  .Q.fpn[.pipe.quote.load;`:/tmp/taq.pipe;5000000];
  .log.Info("time used";.z.P-.pipe.startTime);
  .pipe.quote.post[];
  exit 0
 ];
