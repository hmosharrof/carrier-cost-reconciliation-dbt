"""Generate synthetic seed data (no real company data). Deterministic: same output on every run."""
import csv, random
from pathlib import Path

random.seed(42)
out = Path(__file__).resolve().parent.parent / "seeds"
stores = ["S001", "S002", "S003", "S004", "S005"]
months = ["2026-01", "2026-02", "2026-03", "2026-04", "2026-05", "2026-06"]
carriers = [("C01", "NordFracht (demo)"), ("C02", "Elbe Express (demo)"), ("C03", "Rhein Cargo (demo)")]

deliveries, totals = [], []
n = 0

def add(store, month, carrier, day, count):
    global n
    for i in range(count):
        n += 1
        d = day if day else random.randint(1, 28)
        deliveries.append((f"D{n:06d}", store, carrier, f"{month}-{d:02d}"))

for s in stores:
    for m in months:
        before = len(deliveries)
        if s == "S002":                      # two carriers, roughly 60/40 all year
            add(s, m, "C01", None, 60 + random.randint(-3, 3))
            add(s, m, "C03", None, 40 + random.randint(-3, 3))
        elif s == "S003" and m == "2026-04": # carrier switch on 21 April: new carrier delivers 7%
            for _ in range(93):
                n += 1; deliveries.append((f"D{n:06d}", s, "C01", f"{m}-{random.randint(1, 20):02d}"))
            for _ in range(7):
                n += 1; deliveries.append((f"D{n:06d}", s, "C02", f"{m}-{random.randint(21, 28):02d}"))
        elif s == "S003" and m in ("2026-05", "2026-06"):
            add(s, m, "C02", None, 100 + random.randint(-5, 5))
        else:
            add(s, m, "C01", None, 90 + random.randint(-8, 8))
        count = len(deliveries) - before
        cost = 10000.00 if (s == "S003" and m == "2026-04") else round(count * 12.5 + random.uniform(-40, 40), 2)
        totals.append((s, m, f"{cost:.2f}"))

contracts = [
    ("C01", "S001", "2025-01-01"), ("C01", "S002", "2025-01-01"), ("C03", "S002", "2025-09-01"),
    ("C01", "S003", "2025-01-01"), ("C02", "S003", "2026-04-21"),
    ("C01", "S004", "2025-01-01"), ("C01", "S005", "2025-01-01"),
]

def write(name, header, rows):
    with open(out / f"{name}.csv", "w", newline="") as f:
        w = csv.writer(f); w.writerow(header); w.writerows(rows)

write("carriers", ["carrier_id", "carrier_name"], carriers)
write("deliveries", ["delivery_id", "store_id", "carrier_id", "delivery_date"], deliveries)
write("store_cost_totals", ["store_id", "month", "controlling_total_cost"], totals)
write("carrier_contracts", ["carrier_id", "store_id", "contract_start_date"], contracts)
print(f"{len(deliveries)} deliveries, {len(totals)} store-months")
