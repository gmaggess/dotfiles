#!/usr/bin/env python3
"""Check staged files for private state and personal paths; pair with Gitleaks."""
import re
import subprocess
import sys
from pathlib import PurePosixPath

PRIVATE_PREFIXES = (
    '.aws/', '.ssh/', '.docker/', '.claude/', '.idea/', '.vscode/',
    '.migration/', 'private/', 'private-overlay/',
    '.config/1Password/', '.config/gcloud/', '.config/op/', '.config/.mono/',
    '.config/joplin-desktop/', '.config/manus-computer-operator/',
)
PRIVATE_NAMES = {'hosts.yml', '.netrwhist', '.bash_history', '.zsh_history',
                 '.git-credentials', 'credentials', 'credentials.json'}
PERSONAL_HOME = re.compile(rb'/(?:Users|home)/[A-Za-z0-9_.-]+/')


def check_index():
    entries = subprocess.check_output(['git', 'ls-files', '--stage', '-z']).split(b'\0')
    failures = []
    for entry in entries:
        if not entry:
            continue
        metadata, encoded_name = entry.split(b'\t', 1)
        mode, oid, stage = metadata.decode().split()
        name = encoded_name.decode()
        path = PurePosixPath(name)
        leaf = path.name
        private = (name.startswith(PRIVATE_PREFIXES) or leaf in PRIVATE_NAMES
                   or leaf.endswith(('.local', '.pem', '.key', '.p12', '.pfx', '.sqlite', '.db', '.log'))
                   or leaf in {'.env', 'id_rsa', 'id_ed25519'}
                   or (leaf.startswith('.env.') and leaf != '.env.example'))
        if private:
            failures.append((name, 'private path'))
            continue
        if mode not in {'100644', '100755'} or stage != '0':
            failures.append((name, 'only ordinary files may be published'))
            continue
        data = subprocess.check_output(['git', 'cat-file', 'blob', oid])
        if b'\0' in data:
            failures.append((name, 'binary/application data'))
        elif PERSONAL_HOME.search(data):
            failures.append((name, 'personal home path'))
    for name, reason in failures:
        print(f'{name}: {reason}')
    if not failures:
        print('Public file checks passed.')
    return bool(failures)


if __name__ == '__main__':
    sys.exit(check_index())
