import unittest
import fontParts

class TestFont(unittest.TestCase):

    def test_NewFont(self):
        self.assertIsNotNine(fontParts.NewFont())

unittest.main(module=None, argv=['foo', 'bar'], exit=False)
