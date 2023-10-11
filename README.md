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

```
from datetime import date
from typing import List

import pandas as pd
import pykx


def db_write(
    q: pykx.QConnection, tableName: str, date: date, sortColumns: List[str], data: pd.DataFrame
):
    q(".dbWriter.Write", tableName, date, sortColumns, data)


def db_upsert(
    q: pykx.QConnection, tableName: str, date: date, sortColumns: List[str], data: pd.DataFrame
):
    q(".dbWriter.Upsert", tableName, date, sortColumns, data)


q = pykx.QConnection("localhost", 51800)

data = pd.DataFrame(
    {
        "date": [date.today(), date.today(), date.today()],
        "ric": ["a", "b", "c"],
        "qty": [1, 2, 3],
        "price": [1, 2, 3],
    }
)
# write partition
db_write(q, "trade", date.today(), ["ric"], data)
# upsert partition
db_upsert(q, "trade", date.today(), ["ric"], data)

```
