"""Fail-closed page-extract-v1. Raster Vision only. No OCR, no text layer."""
import json
import unittest
from pathlib import Path

from jsonschema import Draft202012Validator

from page_extract import ContractFailure, validate_page_extract


SOURCE = 'a' * 64
PIXEL = 'b' * 64
PROFILE = 'full-v1'
PAGE = 'page-1'


def extract():
    return {
        'schemaVersion': 'page-extract-v1',
        'sourceHash': SOURCE,
        'pixelHash': PIXEL,
        'renderProfile': PROFILE,
        'pageRef': PAGE,
        'extractionVersion': 'page-vision-extract-v1',
        'coverage': 'complete',
        'blocks': [
            {
                'id': 'b1',
                'order': 0,
                'kind': 'heading',
                'text': 'عنوان',
                'bbox': {'x': 0.1, 'y': 0.05, 'w': 0.4, 'h': 0.04},
                'confidence': 0.92,
                'uncertain': False,
            },
            {
                'id': 'b2',
                'order': 1,
                'kind': 'paragraph',
                'text': 'متن پاراگراف.',
                'bbox': {'x': 0.1, 'y': 0.12, 'w': 0.7, 'h': 0.1},
                'confidence': 0.8,
                'uncertain': False,
            },
            {
                'id': 'b3',
                'order': 2,
                'kind': 'figure',
                'text': '',
                'bbox': {'x': 0.1, 'y': 0.3, 'w': 0.2, 'h': 0.04},
                'confidence': 0.9,
                'uncertain': False,
            },
            {
                'id': 'b4',
                'order': 3,
                'kind': 'unknown',
                'text': '',
                'bbox': {'x': 0.1, 'y': 0.4, 'w': 0.2, 'h': 0.04},
                'confidence': 0.1,
                'uncertain': True,
            },
        ],
        'figures': [
            {
                'id': 'fig-1',
                'blockId': 'b3',
                'bbox': {'x': 0.2, 'y': 0.5, 'w': 0.4, 'h': 0.2},
                'caption': 'شکل ۱',
                'confidence': 0.7,
            },
        ],
    }


class PageExtractTests(unittest.TestCase):
    def test_complete_page_keeps_order_figures_and_quarantine(self):
        valid = extract()
        self.assertEqual(
            validate_page_extract(
                valid, source_hash=SOURCE, pixel_hash=PIXEL,
                render_profile=PROFILE, page_ref=PAGE,
            ),
            valid,
        )
        unknown = valid['blocks'][3]
        self.assertTrue(unknown['uncertain'])
        self.assertEqual(unknown['text'], '')

    def test_rejects_figure_attached_to_non_figure_block(self):
        doc = extract()
        self.assertEqual(
            next(block['kind'] for block in doc['blocks'] if block['id'] == 'b2'),
            'paragraph',
        )
        case = {**doc, 'figures': [{**doc['figures'][0], 'blockId': 'b2'}]}
        with self.assertRaises(ContractFailure) as failure:
            validate_page_extract(
                case, source_hash=SOURCE, pixel_hash=PIXEL,
                render_profile=PROFILE, page_ref=PAGE,
            )
        self.assertEqual(str(failure.exception), 'FIGURE_ATTACHED_TO_NON_FIGURE_BLOCK')

    def test_rejects_two_figures_sharing_one_figure_block(self):
        doc = extract()
        self.assertEqual(
            next(block['kind'] for block in doc['blocks'] if block['id'] == 'b3'),
            'figure',
        )
        second = {**doc['figures'][0], 'id': 'fig-2'}
        case = {**doc, 'figures': [doc['figures'][0], second]}
        with self.assertRaises(ContractFailure) as failure:
            validate_page_extract(
                case, source_hash=SOURCE, pixel_hash=PIXEL,
                render_profile=PROFILE, page_ref=PAGE,
            )
        self.assertEqual(str(failure.exception), 'DUPLICATE_FIGURE_BLOCK')

    def test_rejects_lonely_figure_block_with_no_owning_figure(self):
        doc = extract()
        case = {**doc, 'figures': []}
        with self.assertRaises(ContractFailure) as failure:
            validate_page_extract(
                case, source_hash=SOURCE, pixel_hash=PIXEL,
                render_profile=PROFILE, page_ref=PAGE,
            )
        self.assertEqual(str(failure.exception), 'FIGURE_BLOCK_WITHOUT_FIGURE')

    def test_rejects_figure_block_carrying_text(self):
        doc = extract()
        self.assertEqual(
            next(block['kind'] for block in doc['blocks'] if block['id'] == 'b3'),
            'figure',
        )
        case = {**doc, 'blocks': [
            {**block, 'text': 'smuggled transcription'} if block['id'] == 'b3' else block
            for block in doc['blocks']
        ]}
        with self.assertRaises(ContractFailure) as failure:
            validate_page_extract(
                case, source_hash=SOURCE, pixel_hash=PIXEL,
                render_profile=PROFILE, page_ref=PAGE,
            )
        self.assertEqual(str(failure.exception), 'FIGURE_BLOCK_MUST_BE_TEXTLESS')

    def test_rejects_low_confidence_figure(self):
        doc = extract()
        self.assertEqual(doc['figures'][0]['confidence'], 0.7)
        case = {**doc, 'figures': [{**doc['figures'][0], 'confidence': 0.0}]}
        with self.assertRaises(ContractFailure) as failure:
            validate_page_extract(
                case, source_hash=SOURCE, pixel_hash=PIXEL,
                render_profile=PROFILE, page_ref=PAGE,
            )
        self.assertEqual(str(failure.exception), 'LOW_CONFIDENCE_FIGURE_REJECTED')

    def test_rejects_certain_text_block_without_text(self):
        doc = extract()
        case = {**doc, 'blocks': [
            {**block, 'text': ''} if block['id'] == 'b2' else block
            for block in doc['blocks']
        ]}
        with self.assertRaises(ContractFailure) as failure:
            validate_page_extract(
                case, source_hash=SOURCE, pixel_hash=PIXEL,
                render_profile=PROFILE, page_ref=PAGE,
            )
        self.assertEqual(str(failure.exception), 'EMPTY_TEXT_BLOCK_REJECTED')

    def test_rejects_boolean_order_confidence(self):
        doc = extract()
        order_case = {**doc, 'blocks': [
            {**block, 'order': True} if block['id'] == 'b2' else block
            for block in doc['blocks']
        ]}
        with self.assertRaises(ContractFailure) as failure:
            validate_page_extract(
                order_case, source_hash=SOURCE, pixel_hash=PIXEL,
                render_profile=PROFILE, page_ref=PAGE,
            )
        self.assertEqual(str(failure.exception), 'BLOCKS_NOT_ORDERED')
        conf_case = {**doc, 'blocks': [
            {**block, 'confidence': True} if block['id'] == 'b2' else block
            for block in doc['blocks']
        ]}
        with self.assertRaises(ContractFailure) as failure:
            validate_page_extract(
                conf_case, source_hash=SOURCE, pixel_hash=PIXEL,
                render_profile=PROFILE, page_ref=PAGE,
            )
        self.assertEqual(str(failure.exception), 'INVALID_CONFIDENCE')

    def test_rejects_float_block_order(self):
        doc = extract()
        case = {**doc, 'blocks': [
            {**block, 'order': 1.0} if block['id'] == 'b2' else block
            for block in doc['blocks']
        ]}
        with self.assertRaises(ContractFailure) as failure:
            validate_page_extract(
                case, source_hash=SOURCE, pixel_hash=PIXEL,
                render_profile=PROFILE, page_ref=PAGE,
            )
        self.assertEqual(str(failure.exception), 'BLOCKS_NOT_ORDERED')

    def test_rejects_boolean_figure_confidence(self):
        doc = extract()
        case = {**doc, 'figures': [{**doc['figures'][0], 'confidence': True}]}
        with self.assertRaises(ContractFailure) as failure:
            validate_page_extract(
                case, source_hash=SOURCE, pixel_hash=PIXEL,
                render_profile=PROFILE, page_ref=PAGE,
            )
        self.assertEqual(str(failure.exception), 'INVALID_FIGURE_CONFIDENCE')

    def test_rejects_ocr_text_layer_hash_mismatch_and_partial_coverage(self):
        valid = extract()
        cases = (
            'not-json{',
            {**valid, 'schemaVersion': 'lesson-ast-v1'},
            {**valid, 'sourceHash': 'c' * 64},
            {**valid, 'pixelHash': 'd' * 64},
            {**valid, 'renderProfile': 'thumb-v1'},
            {**valid, 'pageRef': 'page-9'},
            {**valid, 'coverage': 'partial'},
            {**valid, 'provenance': 'ocr'},
            {**valid, 'textLayer': 'stolen text'},
            {**valid, 'blocks': [{**valid['blocks'][0], 'text': '<script>x</script>'}]},
            {**valid, 'figures': [{**valid['figures'][0], 'blockId': 'missing'}]},
            {**valid, 'blocks': [valid['blocks'][1]]},
            {**valid, 'blocks': [
                {**valid['blocks'][0], 'confidence': 0.2, 'uncertain': False},
            ]},
        )
        for case in cases:
            with self.subTest(case=str(case)[:140]):
                with self.assertRaises(ContractFailure):
                    validate_page_extract(
                        case, source_hash=SOURCE, pixel_hash=PIXEL,
                        render_profile=PROFILE, page_ref=PAGE,
                    )

    def test_schema_file_matches_runtime_acceptance(self):
        path = Path(__file__).resolve().parents[2] / 'docs/contracts/page-extract-v1.json'
        schema = json.loads(path.read_text(encoding='utf-8'))
        Draft202012Validator.check_schema(schema)
        validator = Draft202012Validator(schema)
        self.assertEqual(list(validator.iter_errors(extract())), [])
        bad = {**extract(), 'coverage': 'guessed'}
        self.assertTrue(list(validator.iter_errors(bad)))


if __name__ == '__main__':
    unittest.main()
