# db-writer

## Manual

1. update `dbPath` in `ktrl/process/db-writer.process.json`, the path MUST be created before starting the process.
2. (optional)to use `rlwrap`, update `binary` in `ktrl/profile/q4.profile.json` from `q` to `rlwrap q`

```
{
  "envPath": "",
  "binary": "rlwrap q",
  "binaryType": "q",
  "binaryHome": "",
  "licenseDir": "",
  "hostAlias": ""
}
```

3. (optional)to change `port`, update `port` in `ktrl/process/db-writer.process.json`
4. install `kuki` by running `pip install kuki`
5. cd this folder and start process, using the following command

```
ktrl --start --profile q4 --process db-writer
```

## Write data from another q process

```
// if from same linux server, we can just open port number
h: hopen 51800;
// (.dbWriter.Write;tableName;date;sortColumns;data)
data:([]date:.z.D;ric:`a`b;qty:1 2;price:1 2);
// write a new partition
h (`.dbWriter.Write;`trade;.z.D;`ric;data);

// upsert to an exiting partition
h (`.dbWriter.Upsert;`trade;.z.D;`ric;data);

```

## Write data from pykx

> refer `py/test.py`
