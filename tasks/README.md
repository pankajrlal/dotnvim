# tasks

One markdown per task, `NNN_short_description.md`, with YAML frontmatter
(`id`, `title`, `status: open | in-progress | done`, `created`, `depends_on`).
Set `in-progress` when picked up; when done, set `done`, move the file to
`tasks/done/` and add an entry under `changelog/`.
