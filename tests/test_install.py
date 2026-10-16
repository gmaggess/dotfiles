import os
from pathlib import Path
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]

class InstallTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='dotfiles-test-')
        self.addCleanup(self.temp.cleanup)
        self.home = Path(self.temp.name) / 'home with spaces'
        self.home.mkdir()

    def run_install(self, *args):
        return subprocess.run(['bash', str(ROOT / 'symlink-setup.sh'), *args],
                              cwd='/', env={**os.environ, 'HOME': str(self.home)},
                              capture_output=True, text=True)

    def test_dry_run_does_not_write_to_home(self):
        result = self.run_install('--dry-run')
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn('.zshrc', result.stdout)
        self.assertEqual(list(self.home.iterdir()), [])

    def test_install_is_idempotent_and_preserves_application_state(self):
        state = self.home / '.config/gh/hosts.yml'
        state.parent.mkdir(parents=True)
        state.write_text('local authentication state')
        for _ in range(2):
            result = self.run_install()
            self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(state.read_text(), 'local authentication state')
        self.assertTrue((self.home / '.zshrc').is_symlink())
        self.assertFalse((self.home / '.config').is_symlink())
        self.assertFalse((self.home / '.config/gh').is_symlink())
        self.assertFalse((self.home / '.ssh').is_symlink())
        self.assertFalse((self.home / 'bin').is_symlink())
        self.assertFalse((self.home / '.npmrc').is_symlink())
        self.assertFalse((self.home / '.config/pnpm/rc').is_symlink())
        self.assertFalse((self.home / 'Library/Application Support/Code/User/settings.json').is_symlink())

    def test_conflict_is_preserved_and_reported(self):
        original = self.home / '.zshrc'
        original.write_text('existing shell settings')
        result = self.run_install()
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(original.read_text(), 'existing shell settings')
        self.assertIn('conflict', result.stderr.lower())

    def test_symlinked_parent_is_rejected_without_touching_its_target(self):
        external = Path(self.temp.name) / 'external'
        external.mkdir()
        (self.home / '.config').symlink_to(external, target_is_directory=True)
        result = self.run_install()
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('symlink', result.stderr.lower())
        self.assertEqual(list(external.iterdir()), [])
        self.assertFalse((self.home / '.zshrc').exists())

    def test_private_overrides_are_opt_in(self):
        private = Path(self.temp.name) / 'private repo'
        overlay = private / 'private-overlay'
        overlay.mkdir(parents=True)
        ((overlay / '.gitconfig.local').resolve()).write_text('[user]\nname = Example User\n[core]\neditor = vi\n[push]\ndefault = simple\n')
        result = self.run_install('--private-dir', str(private))
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual((self.home / '.gitconfig.local').resolve(), (overlay / '.gitconfig.local').resolve())
        identity = subprocess.run(['git', 'config', '--file', str(self.home / '.gitconfig'),
                                   '--includes', 'user.name'],
                                  env={**os.environ, 'HOME': str(self.home)}, capture_output=True, text=True)
        self.assertEqual(identity.stdout.strip(), 'Example User')

    def test_private_git_settings_override_public_defaults(self):
        private = Path(self.temp.name) / 'private repo'
        overlay = private / 'private-overlay'
        overlay.mkdir(parents=True)
        (overlay / '.gitconfig.local').write_text('[core]\neditor = vi\n[push]\ndefault = simple\n')
        result = self.run_install('--private-dir', str(private))
        self.assertEqual(result.returncode, 0, result.stderr)
        for key, expected in [('core.editor', 'vi'), ('push.default', 'simple')]:
            result = subprocess.run(['git', 'config', '--file', str(self.home / '.gitconfig'),
                                     '--includes', key], env={**os.environ, 'HOME': str(self.home)},
                                    capture_output=True, text=True)
            self.assertEqual(result.stdout.strip(), expected)

    def test_profile_loads_without_optional_environment_script(self):
        result = self.run_install()
        self.assertEqual(result.returncode, 0, result.stderr)
        result = subprocess.run(['/bin/sh', '-c', '. "$HOME/.profile"'],
                                env={**os.environ, 'HOME': str(self.home)},
                                capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(result.stderr, '')

    def test_zsh_loads_without_optional_tools_or_java_installations(self):
        result = self.run_install()
        self.assertEqual(result.returncode, 0, result.stderr)
        result = subprocess.run(['/bin/zsh', '-f', '-c', 'source "$HOME/.zshrc"; print loaded'],
                                env={**os.environ, 'HOME': str(self.home),
                                     'PATH': '/usr/bin:/bin', 'VSCODE_RESOLVING_ENVIRONMENT': '1'},
                                capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(result.stderr, '')
        self.assertEqual(result.stdout.strip(), 'loaded')

    def test_unknown_option_and_missing_private_directory_fail(self):
        self.assertNotEqual(self.run_install('--unknown').returncode, 0)
        self.assertNotEqual(self.run_install('--private-dir', '/no-such-private-directory').returncode, 0)
        self.assertEqual(list(self.home.iterdir()), [])

if __name__ == '__main__':
    unittest.main()
