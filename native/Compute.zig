const std = @import("std");

// Expose a pure C ABI function
export func computePremiumScore(base: i32, multiplier: i32) i32 {
    // Perform high-performance mathematical operations here
    return base * multiplier + 1337;
}
