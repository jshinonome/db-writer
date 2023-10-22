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
5. cd this folder and start process, using ktrl(a command from kuki)

```
ktrl --start --profile q4 --process db-writer
```

## Write data from another q process

```
// if from same linux server, we can just open port number
h: hopen 51800;
// (.dbWriter.Write;tableName;date;sortColumns;data;parUnit)
data:([]date:.z.D;ric:`a`b;qty:1 2;price:1 2;tradeFlag:("test";"test"));
// write a new partition
h (`.dbWriter.Write;`trade;.z.D;`ric;data;`date);

// upsert to an exiting partition
h (`.dbWriter.Upsert;`trade;.z.D;`ric;data;`date;`ric);

```

## Write data from pykx

> refer `py/test.py`

## Load Taq Quote(NBBO) gz

install latest kuki

cd this repo and run the following command, 25min per date, 30MB memory, 3GB disk per date

```
bash script/loadTaq.sh /home/jshinonome/Downloads/taq/EQY_US_ALL_NBBO_20230703.gz ./hdb quote
```

> update this line to use a bigger chunk size

```q
/ src/pipeLoader.q, line 33
  .Q.fpn[.pipe.quote.Load;`:/tmp/taq.pipe;5000000];

```
