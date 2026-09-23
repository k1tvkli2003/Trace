"""OpenCode Go-only policy, offline. No credentials or provider calls."""
import unittest

from go_routing import GoRouting, RouteFailure


class GoRoutingTests(unittest.TestCase):
    def test_all_capabilities_fail_closed_until_go_model_is_selected(self):
        policy = GoRouting()
        for capability in ('structure_scan', 'page_vision_extract',
                           'slice_planner', 'teacher_fa', 'coach'):
            with self.subTest(capability=capability):
                with self.assertRaises(RouteFailure) as caught:
                    policy.resolve(capability)
                self.assertEqual(caught.exception.code, 'GO_MODEL_NOT_CONFIGURED')

    def test_unknown_capability_cannot_invoke_provider(self):
        with self.assertRaises(RouteFailure) as caught:
            GoRouting().resolve('open_web')
        self.assertEqual(caught.exception.code, 'AI_CAPABILITY_NOT_ALLOWED')

    def test_only_go_model_and_official_model_endpoint_pair_can_be_resolved(self):
        route = GoRouting({'teacher_fa': 'opencode-go/glm-5.3-flash'}).resolve('teacher_fa')
        self.assertEqual(route.provider, 'opencode-go')
        self.assertEqual(route.model, 'glm-5.3-flash')
        self.assertEqual(route.endpoint,
                         'https://opencode.ai/zen/go/v1/chat/completions')
        vision = GoRouting({'page_vision_extract': 'opencode-go/deepseek-v4-flash-vision-exp'}).resolve('page_vision_extract')
        self.assertEqual(vision.endpoint, 'https://opencode.ai/zen/go/v1/chat/completions')

    def test_non_go_model_unknown_model_and_incompatible_modality_rejected(self):
        for model, capability in (
            ('openrouter/stealth/union-alpha', 'teacher_fa'),
            ('oc/union-alpha', 'teacher_fa'),
            ('opencode-go/unknown', 'teacher_fa'),
            ('opencode-go/glm-5.3-flash', 'page_vision_extract'),
            ('opencode-go/gpt-5.6-luna', 'page_vision_extract'),
        ):
            with self.subTest(model=model, capability=capability):
                with self.assertRaises(RouteFailure) as caught:
                    GoRouting({capability: model}).resolve(capability)
                self.assertEqual(caught.exception.code, 'AI_ROUTE_NOT_ALLOWED')

    def test_no_dynamic_endpoint_override_or_fallback(self):
        with self.assertRaises(RouteFailure):
            GoRouting({'coach': 'opencode-go/glm-5.3-flash'},
                      endpoint_override='https://localhost/v1/chat/completions')
        with self.assertRaises(RouteFailure) as caught:
            GoRouting({'coach': 'opencode-go/glm-5.3-flash'}).resolve('teacher_fa')
        self.assertEqual(caught.exception.code, 'GO_MODEL_NOT_CONFIGURED')


if __name__ == '__main__':
    unittest.main()
