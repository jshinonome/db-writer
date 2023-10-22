// sortColumns shall be `ric`time
.dbWriter.Write:{[tableName;dt;sortColumns;data;parUnit]
  .log.Info ("writing";count data;"to";tableName;"on";dt);
  data:.Q.en[`:.;data];
  path:.Q.dd[.Q.par[`:.;parUnit$dt;tableName];`];
  data:$[
    parUnit = `date;
      delete date from sortColumns xasc data;
      ![data;();0b;(enlist parUnit)!enlist($;enlist parUnit;dt)]
  ];
  if[not `updTime in cols data;
    data:update updTime:.z.P from data
  ];
  path set @[data;first sortColumns;#[`p]];
  .log.Info ("wrote";count data;"to";tableName;"on";dt);
  :1b
 };

.dbWriter.Upsert:{[tableName;dt;sortColumns;data;parUnit;keyColumns]
  .log.Info ("Upserting";count data;"to";tableName;"on";dt);
  data:$[
    parUnit = `date;
      delete date from sortColumns xasc data;
      ![data;();0b;(enlist parUnit)!enlist($;enlist parUnit;dt)]
  ];
  data:.Q.en[`:.;data];
  if[not `updTime in cols data;
    data:update updTime:.z.P from data
  ];
  partition:parUnit$dt;
  path:.Q.dd[.Q.par[`:.;partition;tableName];`];
  keyColumns:() , keyColumns;
  newKeys:distinct ?[data;();0b;{x!x}(),keyColumns];
  i:?[path;enlist(not;(in;(flip;(!;enlist keyColumns;enlist,keyColumns));newKeys));();`i];
  if[(0 = count i) | count[i] < 1 + max i;
    .log.Info ("Removing";$[0=count i;"all";1 + max[i] - count i];"duplicated keys");
    columns:cols path;
    {[path;column;i] .[.Q.dd[path;column];();@;i] }[path;;i] each columns
  ];
  path upsert data;
  sortColumns xasc path;
  @[path;first sortColumns;#[`p]];
  .log.Info ("Upsert";count data;"to";tableName;"on";dt);
  :1b
 };

.z.zd:17 2 6;
