.cli.Symbol[`hdbPath;`;"upsert hdb path"];
.cli.Symbol[`gzFilepath;`;"filepath"];
.cli.Symbol[`table;`;"table name"];

.z.zd:17 2 6;

.pipe.quote.columns:`Time`Exchange`Symbol`Bid_Price`Bid_Size`Offer_Price`Offer_Size`Quote_Condition,
  `Sequence_Number`National_BBO_Ind`FINRA_BBO_Indicator`FINRA_ADF_MPID_Indicator`Quote_Cancel_Correction,
  `Source_Of_Quote`Retail_Interest_Indicator`Short_Sale_Restriction_Indicator`LULD_BBO_Indicator,
  `SIP_Generated_Message_Identifier`National_BBO_LULD_Indicator`Participant_Timestamp`FINRA_ADF_Timestamp,
  `FINRA_ADF_Market_Participant_Quote_Indicator`Security_Status_Indicator;

.pipe.quote.Load:{
  table:flip .pipe.quote.columns!("NC*FHFHCIHHCCCCCCCCNNCC";"|") 0: x;
  .log.Info ("upserting";count table;"to";string .pipe.parPath);
  upsert[.pipe.parPath] table
 };

.cli.Args:.cli.Parse[];

.pipe.parPath:.Q.dd[
  .Q.par[hsym .cli.Args`hdbPath;"D"$-3_-11#string .cli.Args[`gzFilepath];.cli.Args`table];
  `
 ];

.log.Info ("loading file";string .cli.Args `gzFilepath;"to";string .cli.Args `hdbPath);

.log.Info ("partition";.pipe.parPath);

if[`quote=.cli.Args`table;
  .pipe.startTime:.z.P;
  // use 5MB memory
  .Q.fpn[.pipe.quote.Load;`:/tmp/taq.pipe;5000000];
  .log.Info("time used";.z.P-.pipe.startTime);
  exit 0
 ];
