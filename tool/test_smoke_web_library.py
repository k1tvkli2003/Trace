import unittest
from pathlib import Path


SCRIPT = Path(__file__).with_name('smoke_web_library.py').read_text(encoding='utf-8')


class SmokeWebLibraryContractTest(unittest.TestCase):
    def test_pdf_import_happens_while_selected_then_reload_verifies_bytes(self):
        import_start = SCRIPT.index(
            "if os.environ.get('TRACE_SMOKE_IMPORT') or os.environ.get('TRACE_SMOKE_PDF'):"
        )
        import_block = SCRIPT[
            import_start:SCRIPT.index('call("Page.reload"', import_start)
        ]
        reload_at = SCRIPT.index('call("Page.reload"', import_start)
        after_reload = SCRIPT[reload_at:]

        # The import flow must run against the live, selected collection.
        self.assertIn("manage_x = int(viewport['w'] - 72)", import_block)
        self.assertIn("source_x = int(viewport['w'] * (0.60 if pdf_mode else 0.40))", import_block)
        self.assertIn("source_y = int(viewport['h'] * 0.285)", import_block)
        self.assertIn("call('DOM.setFileInputFiles'", import_block)
        self.assertIn("bytes not stored in SQLite", import_block)
        # Collection selection is UI-only, so no reload may sit between selection
        # and the picker: selection would be lost and the panel would not open.
        self.assertNotIn('Page.reload', import_block)
        # The single reload must re-verify the imported original, not just the title.
        self.assertIn("original lost on reload", after_reload)
        self.assertIn("source_probe", after_reload)

    def test_chrome_closes_before_temporary_profile_cleanup(self):
        self.assertIn('call("Browser.close")', SCRIPT)
        self.assertLess(SCRIPT.index('call("Browser.close")'), SCRIPT.index('proc.terminate()'))

    def test_pdf_fixture_is_real_pdf(self):
        fixture = (
            Path(__file__).parents[1]
            / 'apps' / 'trace_flutter' / 'test' / 'fixtures' / 'dummy.pdf'
        )
        data = fixture.read_bytes()
        self.assertTrue(data.startswith(b'%PDF-'))
        self.assertIn(b'%%EOF', data[-4096:])


if __name__ == '__main__':
    unittest.main()
