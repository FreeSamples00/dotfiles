# Wrappers for external commands to provide structured data

# Wraps GNU strings for structured output
def strings [
  target: string # target file
  --format (-f): string = "hex" # Choose offset unit (hex, octal, decimal)
  --number (-n): int = 4 # Minimum length of string
]: nothing -> table<string, string> {
  let options = [
    "-o"
    # "-a"
    $"-n"
    $"($number)"
    "-t"
    $"(match $format {"hex" => "x", "octal" => "o", "decimal" => "d" })"
    "--"
    $"($target)"
  ]
  ^strings ...$options | lines | parse "{offset} {string}"
}
