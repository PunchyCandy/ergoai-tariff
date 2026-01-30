# ErgoAI Import Tax KB (Facts-Only Demo / Guaranteed Parse)

Your current Ergo compiler configuration is rejecting:
- Prolog arithmetic `is`
- certain operator spellings
- and it is very sensitive to tokenization (e.g., `_?Var`)

This pack is designed to **run a demo immediately** with *no arithmetic, no comparisons, no frames, no strings*.

It encodes:
- shipments + policy outcomes
- `duty/4` and `applicable_rate/3` as facts
- explanations as structured functors

Once your demo is working, we can re-introduce derived computation (rate selection, arithmetic) by
either enabling expert mode or adjusting syntax to your exact Ergo build.

## Load
`['main'].`

## Core queries
- `duty(s1, ?Duty, ?Rate, ?Expl).`
- `applicable_rate(s3, ?Rate, ?Expl).`

## Demo behavior
- s3: exempt (FTA)
- s4: de minimis
- s1: tariff + China override (rate 0.15, duty 150.0)
