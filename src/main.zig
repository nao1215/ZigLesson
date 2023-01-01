const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    std.debug.print("Arguments: {s}\n", .{args});
    try printFileStdout();
}

pub fn printFileStdout() !void {
    const file = try std.fs.cwd().openFile("README.md", .{});
    defer file.close();

    var reader = std.io.bufferedReader(file.reader());
    const in_stream = reader.reader();
    const allocator = std.heap.page_allocator;
    const file_size = try file.getEndPos();
    const contents = try in_stream.readAllAlloc(allocator, file_size);
    defer allocator.free(contents);

    const stdout = std.io.getStdOut().writer();
    try stdout.print("read file value: {c}\n", .{contents});
}
