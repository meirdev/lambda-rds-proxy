import json
import os

import pg8000.native


def handler(event, context):
    results = []

    for host_key in ("RDS_ENDPOINT", "RDS_PROXY_ENDPOINT"):
        conn = pg8000.native.Connection(
            os.environ["DB_USERNAME"],
            host=os.environ[host_key],
            password=os.environ["DB_PASSWORD"],
            database="postgres",
        )

        results += conn.run(
            "SELECT CAST(:host as jsonb);",
            host={
                "host": os.environ[host_key],
                "ok": True,
        })[0]

    return {
        "statusCode": 200,
        "body": json.dumps(results)
    }
