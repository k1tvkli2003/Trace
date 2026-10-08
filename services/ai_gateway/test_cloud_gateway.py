"""RED-1: wire boundary for cloud gateway. No implementation yet."""

import base64
import hashlib
import json
import unittest

from on_demand_run import OnDemandFailure, OnDemandGateway

from cloud_gateway import parse_wire_body


PNG = base64.b64decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGA'
    'hKmMIQAAAABJRU5ErkJggg==')
PIXEL = hashlib.sha256(PNG).hexdigest()
SOURCE = 'a' * 64


def wire(**overrides):
    body = {
        'operation': 'op-1',
        'capability': 'page_vision_extract',
        'page_ref': 'page-1',
        'source_hash': SOURCE,
        'pixel_hash': PIXEL,
        'render_profile': 'test-v1',
        'page_png': base64.b64encode(PNG).decode('ascii'),
        'reasoning_effort': 'high',
        'max_output_tokens': 64,
        'max_elapsed_seconds': 5,
        'idempotency_key': 'key-1',
    }
    body.update(overrides)
    return body


class WireTests(unittest.TestCase):
    def test_wire_rejects_unknown_field(self):
        import json
        bad = wire()
        bad['extra'] = 1
        with self.assertRaises(OnDemandFailure):
            parse_wire_body(json.dumps(bad).encode())

    def test_base64_png_decodes_to_existing_preflight_bytes(self):
        body = parse_wire_body(json.dumps(wire()).encode())
        self.assertEqual(body['page_png'], PNG)

    def test_wire_rejects_ambiguous_or_nonfinite_json(self):
        cases = [
            b'{"operation":"x","operation":"y"}',
            json.dumps(wire(max_elapsed_seconds=float('nan'))).encode(),
            json.dumps(wire(max_elapsed_seconds=float('inf'))).encode(),
            json.dumps(wire()).replace('"max_elapsed_seconds": 5',
                                      '"max_elapsed_seconds": 1e999').encode(),
            b'[' * 100 + b'0' + b']' * 100,
            b'\xff', b'[]', b'{',
        ]
        for raw in cases:
            with self.subTest(raw=raw[:40]):
                with self.assertRaises(OnDemandFailure):
                    parse_wire_body(raw)

    def test_wire_rejects_noncanonical_or_non_png_base64(self):
        for image in (None, 123, '', '%%%', 'data:image/png;base64,AA==',
                      base64.b64encode(PNG).decode() + '\n',
                      base64.b64encode(b'not-png').decode(),
                      base64.b64encode(PNG).decode() + '===='):
            with self.subTest(image=str(image)[:30]):
                with self.assertRaises(OnDemandFailure):
                    parse_wire_body(json.dumps(wire(page_png=image)).encode())

    def test_wire_checks_all_eleven_fields_before_claim(self):
        for overrides in ({'pixel_hash': 'b' * 64}, {'max_output_tokens': True},
                          {'max_output_tokens': 0}, {'reasoning_effort': 'low'},
                          {'max_elapsed_seconds': 601}, {'capability': 'teacher_fa'},
                          {'idempotency_key': 'bad key'}):
            with self.subTest(overrides=overrides):
                with self.assertRaises(OnDemandFailure):
                    parse_wire_body(json.dumps(wire(**overrides)).encode())

    def test_wire_three_mib_ceiling_preserves_in_process_four_mib(self):
        large_png = b'\x89PNG\r\n\x1a\n' + b'x' * (3 * 1024 * 1024 - 8)
        large = wire(page_png=base64.b64encode(large_png).decode(),
                     pixel_hash=hashlib.sha256(large_png).hexdigest())
        self.assertEqual(parse_wire_body(json.dumps(large).encode())['page_png'], large_png)
        over = large_png + b'x'
        too_big = wire(page_png=base64.b64encode(over).decode(),
                       pixel_hash=hashlib.sha256(over).hexdigest())
        with self.assertRaises(OnDemandFailure):
            parse_wire_body(json.dumps(too_big).encode())
        in_process = wire(page_png=over, pixel_hash=hashlib.sha256(over).hexdigest())
        validator = OnDemandGateway(verify_owner=lambda _: 'unused', run_vision=lambda _: {})
        self.assertEqual(validator._check(in_process)[0], over)

    def test_wire_oversize_rejected_even_for_whitespace(self):
        with self.assertRaises(OnDemandFailure):
            parse_wire_body(b' ' * (4 * 1024 * 1024 + 16385))


if __name__ == '__main__':
    unittest.main()
