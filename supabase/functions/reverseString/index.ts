// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
import "jsr:@supabase/functions-js/edge-runtime.d.ts"

console.log("Hello from Functions!")

export const handler = async (req: Request) => {
  const url = new URL(req.url);
  const text = url.searchParams.get("text") || "";
  const reversedText = text.split("").reverse().join("");

  return new Response(JSON.stringify({ reversed: reversedText }), {
    headers: { "Content-Type": "application/json" },
  });
};

// Start the server
Deno.serve(handler);

