from pathlib import Path
import os
import subprocess
import tempfile
import unittest

CHECK = Path(__file__).resolve().parents[1] / 'scripts/check-public.py'

class PublicCheckTests(unittest.TestCase):
    def run_check(self, name, content):
        with tempfile.TemporaryDirectory(prefix='dotfiles-check-') as temp:
            root = Path(temp)
            subprocess.run(['git', 'init', '-q', temp], check=True)
            target = root / name
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_text(content)
            subprocess.run(['git', '-C', temp, 'add', '-f', '--', name], check=True)
            return subprocess.run(['python3', str(CHECK)], cwd=temp,
                                  capture_output=True, text=True)

    def test_blocks_authentication_state(self):
        result = self.run_check('.config/gh/hosts.yml', 'local auth state')
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('private path', result.stdout)

    def test_blocks_personal_absolute_paths(self):
        result = self.run_check('settings.json', '{"path": "/' + 'Users/example-person/dev"}')
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('personal home path', result.stdout)

    def test_scans_staged_content_even_when_working_file_is_clean(self):
        with tempfile.TemporaryDirectory(prefix='dotfiles-check-') as temp:
            subprocess.run(['git', 'init', '-q', temp], check=True)
            p = Path(temp) / 'config'
            p.write_text('/' + 'Users/example-person/dev')
            subprocess.run(['git', '-C', temp, 'add', 'config'], check=True)
            p.write_text('clean working copy')
            result = subprocess.run(['python3', str(CHECK)], cwd=temp, capture_output=True, text=True)
            self.assertNotEqual(result.returncode, 0)
            self.assertIn('personal home path', result.stdout)

    def test_allows_generic_configuration(self):
        result = self.run_check('config', 'export EDITOR="code --wait"\n')
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

if __name__ == '__main__':
    unittest.main()
