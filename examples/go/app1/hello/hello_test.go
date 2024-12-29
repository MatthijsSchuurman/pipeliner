package hello

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestHello(t *testing.T) {
	t.Run("should return Hello, world!", func(t *testing.T) {
		// Given
		expected := "Hello, world!"

		// When
		actual := Hello()

		// Then
		assert.Equal(t, expected, actual)
	})
}
