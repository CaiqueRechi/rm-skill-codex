# Splitting one file across several commits

Read this when a single file's changes belong to more than one commit and you
need to stage part of it. It is not needed for anything else.

## Prefer `git add -p`

If interactive git works, use it. It is the shortest path and it shows you each
hunk before you take it.

Interactive git flags are frequently unavailable to an agent, though, in which
case the patch prompt never appears and you need the manual route below.

## Building the index by hand

The idea: the working tree keeps the finished content the whole time, and you
place a *different* blob in the index for the commit you are making. Nothing is
at risk, because you never modify the file on disk.

1. Produce the intended intermediate content of the file — the finished version
   minus the parts that belong to a later commit.
2. Write it as a blob: `git hash-object -w --stdin`, feeding the content on
   stdin. It prints the sha.
3. Place it in the index:
   `git update-index --add --cacheinfo 100644,<sha>,<path>`
4. Commit with `git commit` and **no** `-a`. That commits the index; `-a` would
   sweep the working tree back in and undo the whole exercise.

Repeat for the next commit, and let the last one take the file whole with a
plain `git add`.

## Two traps

**Read and write bytes, not text.** In Python, `subprocess` with `text=True`
and `open()` in text mode both normalise line endings. On a CRLF file that
rewrites every line, so the diff becomes the entire file and the split silently
collapses into a full-file rewrite. Use `capture_output=True` without `text`,
and `open(path, 'rb')`.

**Verify each slice before committing.** `git diff --cached --stat` should show
only the lines that belong to that commit. A slice that reports the whole file
means the byte problem above, or an anchor that did not match.

## Worked shape

```python
import subprocess

def stage(path, content_bytes):
    sha = subprocess.run(
        ['git', 'hash-object', '-w', '--stdin'],
        input=content_bytes, capture_output=True
    ).stdout.decode().strip()

    subprocess.run(
        ['git', 'update-index', '--add', '--cacheinfo', f'100644,{sha},{path}'],
        check=True
    )
```

To build the intermediate content, the reliable move is to slice the finished
file between two anchors you can find literally — the start of the block that
belongs to the later commit, and the start of whatever follows it — and drop
that slice. Deriving it from the committed version and re-applying one change
works too, and is safer when the file was heavily rewritten.
