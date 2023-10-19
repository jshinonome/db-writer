.cli.Symbol[`hdbPath;`;"upsert hdb path"];
.cli.Symbol[`gzFilepath;`;"filepath"];
.cli.Symbol[`table;`;"table name"];

.z.zd:17 2 6;

.pipe.quote.columns:(!) . flip (
  (`Time                                        ;"N"); / "N"
  (`Exchange                                    ;"C"); / "C"
  (`Symbol                                      ;"*"); / "*"
  (`Bid_Price                                   ;"F"); / "F"
  (`Bid_Size                                    ;"H"); / "H"
  (`Offer_Price                                 ;"F"); / "F"
  (`Offer_Size                                  ;"H"); / "H"
  (`Quote_Condition                             ;"C"); / "C"
  (`Sequence_Number                             ;"I"); / "I"
  (`National_BBO_Ind                            ;"H"); / "H"
  (`FINRA_BBO_Indicator                         ;"H"); / "H"
  (`FINRA_ADF_MPID_Indicator                    ;"C"); / "C"
  (`Quote_Cancel_Correction                     ;"C"); / "C"
  (`Source_Of_Quote                             ;"C"); / "C"
  (`Retail_Interest_Indicator                   ;"C"); / "C"
  (`Short_Sale_Restriction_Indicator            ;"C"); / "C"
  (`LULD_BBO_Indicator                          ;"C"); / "C"
  (`SIP_Generated_Message_Identifier            ;"C"); / "C"
  (`National_BBO_LULD_Indicator                 ;"C"); / "C"
  (`Participant_Timestamp                       ;"N"); / "N"
  (`FINRA_ADF_Timestamp                         ;"N"); / "N"
  (`FINRA_ADF_Market_Participant_Quote_Indicator;"C"); / "C"
  (`Security_Status_Indicator                   ;"C") / "C"
 );

.pipe.quote.load:{
  table:flip (where .pipe.quote.columns<>" ")!(value .pipe.quote.columns;"|") 0: x;
  .log.Info ("upserting";count table;"to";string .pipe.parPath);
  upsert[.pipe.parPath] table
 };

.pipe.quote.post:{
  / cast Symbol column to symbol type and enumerate it
  symColPath:.Q.dd[.pipe.parPath;`Symbol];
  symFilePath:.Q.dd[.pipe.hdbPath;`sym];
  .log.Info ("enumerating and applying p attribute";symColPath);
  symValue:`p# symFilePath?`$get symColPath;
  symColPath set symValue;
  .log.Info ("finished enumerating and applying p attribute")
 };

.cli.Args:.cli.Parse[];

.pipe.hdbPath:hsym .cli.Args `hdbPath;

if[11h=not type key .pipe.hdbPath;
  .log.Error(.pipe.hdbPath;"not found or not a directory");
  exit 1;
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
