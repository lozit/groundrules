#!/usr/bin/env python3
# generated-by: groundrules v1.5.0 (prototype fixture)
#
# Pre-written ACCEPTANCE TEST for the slugify fixture task.
# Authored in *reflection* (before any implementation) — it is the executable form of the spec and the
# loop's verifiable back pressure. The maker may NOT edit this file to make it pass.
#
# Run:  python3 test_slugify.py      (exit 0 = green, exit 1 = red).  Stdlib only, no pytest needed.

import sys

try:
    from slugify import slugify
except Exception as e:  # noqa: BLE001 — red-before-code: no implementation yet
    print(f"FAIL: cannot import slugify(): {e!r}")
    sys.exit(1)

CASES = [
    # (input, expected)
    ("Hello World", "hello-world"),
    ("  Hello   World  ", "hello-world"),          # leading/trailing/collapsed whitespace
    ("Hello, World!", "hello-world"),              # punctuation dropped
    ("C++ & Python", "c-python"),                  # symbols dropped, hyphen runs collapsed
    ("---foo---", "foo"),                          # leading/trailing hyphens stripped
    ("already-slugged", "already-slugged"),        # idempotent on a clean slug
    ("MiXeD CaSe 123", "mixed-case-123"),          # digits kept, lowercased
    ("", ""),                                       # empty input
    ("   ", ""),                                    # whitespace-only → empty
    ("a\t\nb", "a-b"),                              # tabs/newlines are whitespace
]


def main() -> int:
    failures = []
    for text, expected in CASES:
        try:
            got = slugify(text)
        except Exception as e:  # noqa: BLE001
            failures.append(f"slugify({text!r}) raised {e!r}; expected {expected!r}")
            continue
        if got != expected:
            failures.append(f"slugify({text!r}) == {got!r}; expected {expected!r}")

    if failures:
        print(f"FAIL: {len(failures)}/{len(CASES)} cases failed")
        for f in failures:
            print("  -", f)
        return 1

    print(f"PASS: {len(CASES)}/{len(CASES)} cases green")
    return 0


if __name__ == "__main__":
    sys.exit(main())
