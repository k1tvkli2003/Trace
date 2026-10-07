"""Trace 9Router Muse-Spark-only routing policy. Offline; no provider call."""
import unittest

from go_routing import NineRouterRouting, RouteFailure


class NineRouterRoutingTests(unittest.TestCase):
    def test_only_verified_opencode_route_for_all_capabilities(self):
        policy = NineRouterRouting()
        routes = [policy.resolve(capability) for capability in
                  ('teacher_fa', 'structure_scan', 'page_vision_extract', 'coach')]
        self.assertEqual([r.model for r in routes],
                         ['ocz/muse-spark-1.3-contributor-free'] * 4)
        self.assertTrue(all(r.provider == '9router' for r in routes))
        self.assertTrue(all(r.endpoint == 'http://127.0.0.1:20128/v1/responses' for r in routes))

    def test_rejects_retired_route_without_silent_model_fallback(self):
        with self.assertRaises(RouteFailure) as caught:
            NineRouterRouting(models=('oc/muse-spark-1.3-contributor-free',))
        self.assertEqual(caught.exception.code, 'AI_ROUTE_NOT_ALLOWED')

    def test_reasoning_effort_is_high_for_vision_and_text(self):
        vision_route = NineRouterRouting().resolve('page_vision_extract')
        text_route = NineRouterRouting().resolve('teacher_fa')
        self.assertEqual(vision_route.reasoning_effort, 'high')
        self.assertEqual(text_route.reasoning_effort, 'high')

    def test_xhigh_is_allowed_explicitly(self):
        vision_route = NineRouterRouting(reasoning_effort='xhigh').resolve('page_vision_extract')
        text_route = NineRouterRouting(reasoning_effort='xhigh').resolve('teacher_fa')
        self.assertEqual(vision_route.reasoning_effort, 'xhigh')
        self.assertEqual(text_route.reasoning_effort, 'xhigh')

    def test_invalid_reasoning_effort_fails_closed(self):
        with self.assertRaises(RouteFailure) as caught:
            NineRouterRouting(reasoning_effort='low')
        self.assertEqual(caught.exception.code, 'AI_ROUTE_NOT_ALLOWED')

    def test_vision_input_is_allowed_as_page_image_not_pdf(self):
        route = NineRouterRouting().resolve('page_vision_extract')
        self.assertTrue(route.accepts_images)
        self.assertFalse(route.accepts_pdf)

    def test_unknown_capability_fails_closed_without_advancing_rotation(self):
        policy = NineRouterRouting()
        with self.assertRaises(RouteFailure) as caught:
            policy.resolve('open_web')
        self.assertEqual(caught.exception.code, 'AI_CAPABILITY_NOT_ALLOWED')
        self.assertEqual(policy.resolve('teacher_fa').model, 'ocz/muse-spark-1.3-contributor-free')

    def test_override_or_alternate_model_is_rejected(self):
        for kwargs in (
            {'endpoint_override': 'https://opencode.ai/zen/go/v1/chat/completions'},
            {'models': ('oc/mimo-v2.6-flash-free', 'ocz/mimo-v2.6-flash-free')},
            {'models': ('ocz/muse-spark-1.3-contributor-free', 'ocz/muse-spark-1.3-contributor-free')},
            {'models': ('ocz/muse-spark-1.3-contributor-free', 'ocz/muse-spark-1.3-contributor-free')},
        ):
            with self.subTest(kwargs=kwargs):
                with self.assertRaises(RouteFailure) as caught:
                    NineRouterRouting(**kwargs)
                self.assertEqual(caught.exception.code, 'AI_ROUTE_NOT_ALLOWED')


if __name__ == '__main__':
    unittest.main()
