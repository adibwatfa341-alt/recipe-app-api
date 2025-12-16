"""
Sample tests
"""
from django.test import SimpleTestCase

from app import calc


class CalcTests(SimpleTestCase):
    """Test the calc module."""


    def test_add_numbers(self):
        """Test adding the numbers together."""
        res = calc.add(5, 6)

        self.assertEqual(res, 11)


    def test_subtrac_number(self):
        """Test subtracting number."""
        res = calc.subtract(10, 15)

        self.assertEqual(res, 5)
