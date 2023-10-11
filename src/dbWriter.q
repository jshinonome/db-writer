// sortColumns shall be `ric`time
.dbWriter.Write:{[tableName;dt;sortColumns;data]
  .log.Info ("writing";count data;"to";tableName;"on";dt);
  data: .Q.en[`:.;data];
  path: .Q.dd[.Q.par[`:.;dt;tableName];`];
  data: delete date from sortColumns xasc data;
  path set @[data;first sortColumns;#[`p]];
  .log.Info ("wrote";count data;"to";tableName;"on";dt);
  :1b;
 };

.dbWriter.Upsert:{[tableName;dt;sortColumns;data]
  .log.Info ("Upserting";count data;"to";tableName;"on";dt);
  data: delete date from .Q.en[`:.;data];
  path: .Q.dd[.Q.par[`:.;dt;tableName];`];
  path upsert data;
  sortColumns xasc path;
  @[path;first sortColumns;#[`p]];
  .log.Info ("Upsert";count data;"to";tableName;"on";dt);
  :1b;
 };
