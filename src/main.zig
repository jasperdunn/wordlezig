const std = @import("std");
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    try loadWords();

    try stdout.print("{s}, {s}?\n", .{ colorText("Is this", Color.value(.fg_red)), "red" });
}

pub fn loadWords() !void {
    var file = try std.fs.cwd().openFile("words.json", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var buffer: [16]u8 = undefined; //1024??

    var i: u16 = 0;
    while (try in_stream.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        i += 1;
        try stdout.print("{}. {s}\n", .{ i, line });
    }

    // file size
    // const stat = try file.stat();
    // try stdout.print("{}\n", .{ std.fmt.fmtIntSizeDec(stat.size) });
}

const Color = enum {
    fg_red,
    fg_green,
    fg_yellow,
    fg_blue,
    fg_purple,
    bg_red,
    bg_green,
    bg_yellow,
    bg_blue,
    bg_purple,

    fn value(self: Color) []const u8 {
        const result = switch (self) {
            .fg_red => "\x1B[1;31m",
            .fg_green => "\x1B[1;32m",
            .fg_yellow => "\x1B[1;33m",
            .fg_blue => "\x1B[1;34m",
            .fg_purple => "\x1B[1;35m",
            .bg_red => "\x1B[1;41m",
            .bg_green => "\x1B[1;42m",
            .bg_yellow => "\x1B[1;43m",
            .bg_blue => "\x1B[1;44m",
            .bg_purple => "\x1B[1;45m"
        };

        return result;
    }
};

pub fn colorText(text: []const u8, color: []const u8) ![]u8 {
    const reset = "\x1B[0m";
    const allocator = std.heap.page_allocator;
    return std.fmt.allocPrint(allocator, "{s}{s}{s}", .{color, text, reset});
}

test "basic test" {
    try std.testing.expectEqual(10, 3 + 7);
}