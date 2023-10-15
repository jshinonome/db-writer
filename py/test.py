from datetime import date
from typing import List, Literal

import pandas as pd
import pykx


def db_write(
    q: pykx.QConnection,
    tableName: str,
    date: date,
    sortColumns: List[str],
    data: pd.DataFrame,
    partitionUnit: Literal["year", "month", "date"],
):
    q(".dbWriter.Write", tableName, date, sortColumns, data, partitionUnit)


def db_upsert(
    q: pykx.QConnection,
    tableName: str,
    date: date,
    sortColumns: List[str],
    data: pd.DataFrame,
    partitionUnit: Literal["year", "month", "date"],
):
    q(".dbWriter.Upsert", tableName, date, sortColumns, data, partitionUnit)


q = pykx.QConnection("localhost", 51800)

data = pd.DataFrame(
    {
        "date": [date.today(), date.today(), date.today()],
        "ric": ["a", "b", "c"],
        "qty": [1, 2, 3],
        "price": [1, 2, 3],
        "tradeFlag": ["open", "", "close"],
    }
)
# cast to bytes, hence save as kdb string
data.tradeFlag = data.tradeFlag.apply(lambda s: bytes(s, "utf-8"))

# write partition
db_write(q, "trade", date.today(), ["ric"], data, "year")
# upsert partition
db_upsert(q, "trade", date.today(), ["ric"], data, "year")
