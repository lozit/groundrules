#!/usr/bin/env python3
# generated-by: groundrules v1.6.0 (loop walkthrough fixture)
#
# Pre-written ACCEPTANCE TEST for the slugify task — the loop's back pressure.
# Authored in *reflection*, BEFORE any implementation: it is currently RED (no widgetkit/text.py yet),
# which is exactly what /groundrules:realize requires before tagging the task [loop] (writer != maker).
# The maker makes it green; it must never be edited to fit the implementation.
#
# Run from the project root:  python3 test/test_slugify.py   (exit 0 = green, 1 = red). Stdlib only.

import sys, os
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

try:
    from widgetkit.text import slugify
except Exception as e:  # red-before-code: the module/function doesn't exist yet
    print(f"FAIL: cannot import slugify(): {e!r}")
    sys.exit(1)

CASES = [
    ("Hello World", "hello-world"),
    ("  Hello   World  ", "hello-world"),
    ("Hello, World!", "hello-world"),
    ("C++ & Python", "c-python"),
    ("---foo---", "foo"),
    ("already-slugged", "already-slugged"),
    ("MiXeD CaSe 123", "mixed-case-123"),
    ("", ""),
    ("   ", ""),
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
