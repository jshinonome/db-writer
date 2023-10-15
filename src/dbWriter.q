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
  path set @[data;first sortColumns;#[`p]];
  .log.Info ("wrote";count data;"to";tableName;"on";dt);
  :1b
 };

.dbWriter.Upsert:{[tableName;dt;sortColumns;data;parUnit]
  .log.Info ("Upserting";count data;"to";tableName;"on";dt);
  data:$[
    parUnit = `date;
      delete date from sortColumns xasc data;
      ![data;();0b;(enlist parUnit)!enlist($;enlist parUnit;dt)]
  ];
  data:.Q.en[`:.;data];
  path:.Q.dd[.Q.par[`:.;parUnit$dt;tableName];`];
  path upsert data;
  sortColumns xasc path;
  @[path;first sortColumns;#[`p]];
  .log.Info ("Upsert";count data;"to";tableName;"on";dt);
  :1b
 };

.z.zd:17 2 6;
