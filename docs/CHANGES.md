v2.0.3

- Cleaned up workflow: removed non-functional Discord notification stubs
- Workflow now focuses solely on packaging and release via BigWigs packager

v2.0.2

- Fixed GitHub Actions workflow `if` conditionals to use canonical expression syntax
- Removed redundant `${{ }}` wrappers from conditional steps

v2.0.1

- Hardened slash command and event handling with protected calls so runtime errors surface cleanly instead of breaking addon execution
- Added setting validation and safer sound playback checks to keep invalid state from silently failing

v2.0.0

- Renamed addon files, TOCs, and package metadata from `OSRSLU` to `RunescapeLevelUp`
- Reworked the addon to match the modern RGX sound addon structure with `data/core.lua`, `data/locales.lua`, and `docs/`
- Added `RSLUSettings`, `/rslu` slash commands, welcome message toggle, and refreshed RuneScape-style branding
- Replaced the old single sound file with `old_school_runescape_high.ogg`, `old_school_runescape_med.ogg`, and `old_school_runescape_low.ogg`
- Added `docs/description.html`, `docs/ROADMAP.md`, and tag-driven `release.yml` packaging workflow
