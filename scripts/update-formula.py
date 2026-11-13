#!/usr/bin/env python3
"""Point Formula/gitaway.rb at a gitaway release.

Usage: scripts/update-formula.py [VERSION]

With no VERSION it uses the latest full release of nikkel/gitaway (the GitHub
"latest" release, which never is a pre-release). For each platform it downloads
the archive, checks its GitHub artifact attestation against the release tag,
computes the SHA-256 itself, and writes the version (in each url) and the hashes into the formula.
Nothing is written unless every archive verifies. Needs `gh` (logged in or with
GH_TOKEN set) and Python 3.

To add a platform, add its target to TARGETS and a matching url/sha256 pair to
the formula.
"""
import hashlib
import json
import pathlib
import re
import subprocess
import sys
import tempfile

REPO = "nikkel/gitaway"
FORMULA = pathlib.Path(__file__).resolve().parent.parent / "Formula" / "gitaway.rb"
TARGETS = [
    "aarch64-apple-darwin",
    "x86_64-apple-darwin",
    "aarch64-unknown-linux-musl",
    "x86_64-unknown-linux-musl",
]


def gh(*args: str) -> str:
    return subprocess.run(["gh", *args], check=True, capture_output=True, text=True).stdout


def latest_version() -> str:
    release = json.loads(gh("release", "view", "--repo", REPO, "--json", "tagName"))
    return release["tagName"].removeprefix("v")


def verified_sha256(tag: str, target: str, workdir: pathlib.Path) -> str:
    archive = f"gitaway-{target}.tar.xz"
    gh("release", "download", tag, "--repo", REPO, "--pattern", archive, "--dir", str(workdir))
    path = workdir / archive
    gh("attestation", "verify", str(path), "--repo", REPO, "--source-ref", f"refs/tags/{tag}")
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    version = sys.argv[1] if len(sys.argv) > 1 else latest_version()
    if not re.fullmatch(r"\d+\.\d+\.\d+", version):
        sys.exit(f"not a full release version: {version}")
    tag = f"v{version}"

    with tempfile.TemporaryDirectory() as tmp:
        hashes = {t: verified_sha256(tag, t, pathlib.Path(tmp)) for t in TARGETS}

    text = FORMULA.read_text()
    text = re.sub(r"/releases/download/v[^/]+/", f"/releases/download/v{version}/", text)
    for target, digest in hashes.items():
        pattern = rf'(gitaway-{re.escape(target)}\.tar\.xz"\n\s+sha256 )"[0-9a-f]+"'
        text, count = re.subn(pattern, rf'\1"{digest}"', text)
        if count != 1:
            sys.exit(f"formula has no url/sha256 pair for {target}")
    FORMULA.write_text(text)
    print(f"formula now at {version}")


if __name__ == "__main__":
    main()
