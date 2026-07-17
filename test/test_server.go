package main

import (
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestAuthMiddleware(t *testing.T) {
	// 1. Create a dummy handler to act as our endpoint
	nextHandler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
	})

	// 2. Define the matrix of test cases
	tests := []struct {
		name           string
		authHeader     string
		expectedStatus int
	}{
		{
			name:           "Missing Authorization Header",
			authHeader:     "",
			expectedStatus: http.StatusUnauthorized,
		},
		{
			name:           "Malformed Token Prefix",
			authHeader:     "Basic invalid-token-string",
			expectedStatus: http.StatusUnauthorized,
		},
		{
			name:           "Valid Token Structure",
			authHeader:     "Bearer valid-mock-token", // Update to a valid generated JWT in your tests
			expectedStatus: http.StatusOK,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			// Setup Request and Response recorder
			req := httptest.NewRequest("GET", "/api/user?id=1", nil)
			if tt.authHeader != "" {
				req.Header.Set("Authorization", tt.authHeader)
			}
			rr := httptest.NewRecorder()

			// Wrap handler in middleware and run
			handlerToTest := authMiddleware(nextHandler)
			handlerToTest.ServeHTTP(rr, req)

			if rr.Code != tt.expectedStatus {
				t.Errorf("Expected status code %d, but got %d", tt.expectedStatus, rr.Code)
			}
		})
	}
}
