import { assertEquals } from "https://deno.land/std@0.114.0/testing/asserts.ts";

// Mock Request creation helper
function createMockRequest(text: string): Request {
  return new Request(
    `http://localhost:8000/?text=${encodeURIComponent(text)}`
  );
}

// Import the handler function
import { handler } from "./index.ts";

Deno.test("Reverse String Function", async () => {
    // Mock request
    const request = new Request("http://localhost:54321/functions/v1/reverseString?text=hello");
  
    // Call the handler function
    const response = await handler(request);
    const json = await response.json();
  
    // Check if the response is correct
    assertEquals(json.reversed, "olleh");
  });