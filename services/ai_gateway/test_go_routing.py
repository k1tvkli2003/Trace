"""Trace 9Router MiMo-only routing policy. Offline; no provider call."""
import unittest

from go_routing import NineRouterRouting, RouteFailure


class NineRouterRoutingTests(unittest.TestCase):
    def test_round_robin_alternates_across_oc_and_ocz(self):
        policy = NineRouterRouting()
        routes = [policy.resolve('teacher_fa') for _ in range(4)]
        self.assertEqual([r.model for r in routes], [
            'oc/mimo-v2.6-flash-free', 'ocz/mimo-v2.6-flash-free',
            'oc/mimo-v2.6-flash-free', 'ocz/mimo-v2.6-flash-free',
        ])
        self.assertTrue(all(r.provider == '9router' for r in routes))
        self.assertTrue(all(r.endpoint == 'http://127.0.0.1:20128/v1/chat/completions' for r in routes))

    def test_all_ai_capabilities_share_one_rotation(self):
        policy = NineRouterRouting()
        self.assertEqual(policy.resolve('structure_scan').model, 'oc/mimo-v2.6-flash-free')
        self.assertEqual(policy.resolve('page_vision_extract').model, 'ocz/mimo-v2.6-flash-free')
        self.assertEqual(policy.resolve('coach').model, 'oc/mimo-v2.6-flash-free')

    def test_vision_input_is_allowed_as_page_image_not_pdf(self):
        route = NineRouterRouting().resolve('page_vision_extract')
        self.assertTrue(route.accepts_images)
        self.assertFalse(route.accepts_pdf)

    def test_unknown_capability_fails_closed_without_advancing_rotation(self):
        policy = NineRouterRouting()
        with self.assertRaises(RouteFailure) as caught:
            policy.resolve('open_web')
        self.assertEqual(caught.exception.code, 'AI_CAPABILITY_NOT_ALLOWED')
        self.assertEqual(policy.resolve('teacher_fa').model, 'oc/mimo-v2.6-flash-free')

    def test_override_or_alternate_model_is_rejected(self):
        for kwargs in (
            {'endpoint_override': 'https://opencode.ai/zen/go/v1/chat/completions'},
            {'models': ('oc/muse-spark-1.3-contributor-free', 'ocz/mimo-v2.6-flash-free')},
            {'models': ('oc/mimo-v2.6-flash-free',)},
            {'models': ('ocz/mimo-v2.6-flash-free', 'oc/mimo-v2.6-flash-free')},
        ):
            with self.subTest(kwargs=kwargs):
                with self.assertRaises(RouteFailure) as caught:
                    NineRouterRouting(**kwargs)
                self.assertEqual(caught.exception.code, 'AI_ROUTE_NOT_ALLOWED')


if __name__ == '__main__':
    unittest.main()
