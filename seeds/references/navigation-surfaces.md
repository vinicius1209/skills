# Navigation Surfaces — New-Screen Checklist

> Reference for any agent (architect / dev) adding a new screen.
> **The core idea:** adding one screen touches N surfaces, not just a route.
> Forgetting a surface is a recurring bug — a screen that has no menu entry, a
> breadcrumb that shows a raw slug, or a route with no permission guard.

Use this as a fill-in template. Replace `<...>` placeholders with your project's
real files and values; delete rows that don't apply to your stack.

---

## The surfaces

| # | Surface | Lives in | Update when | Permission gate |
|---|---------|----------|-------------|-----------------|
| 1 | **Route registration** | `<router-file>` | always | route guard / wrapper |
| 2 | **Sidebar / nav entry** | `<nav-file>` | screen is a navigable entry point (not a detail view) | role/capability flag on the item |
| 3 | **Settings / menu entry** | `<settings-file>` | screen belongs in a settings or admin area | admin/dev gate |
| 4 | **Breadcrumb label** | `<breadcrumb-file>` | the URL slug differs from the human label | n/a |
| 5 | **Route guard / permissions** | `<router-file>` | always (it is a conscious decision) | public / authed / admin / custom |
| 6 | **Top bar (global header)** | `<shell-file>` | the item is a global header element (badge, shortcut, indicator) | authenticated user |

---

## Per-surface notes

### 1 + 5. Route registration & guard

Register the route and make a **deliberate** decision about who can reach it.
Don't leave the guard implicit.

| Access level | Wrapper |
|--------------|---------|
| Public / any authenticated user | no guard wrapper |
| Admin-only | admin guard wrapper |
| Admin or elevated role | guard with the elevated flag |
| Custom rule | gate inside the page (redirect if unauthorized) |

### 2. Sidebar / nav entry

Add the item to the correct nav section with an icon and its permission flag.
**Detail views do not go in the sidebar** (e.g. `/<entity>/:id`) — only entry
points (lists, dashboards, management screens).

### 3. Settings / menu entry

If the screen is a configuration/admin surface, add it to the settings grid or
admin menu rather than the main sidebar.

### 4. Breadcrumb label

Map the slug to a human label. Without this, the breadcrumb renders the raw slug
(e.g. `my-new-screen` instead of "My New Screen"). Add the mapping in the **same
change** as the route — this is the single most-forgotten surface.

### 6. Top bar (global header)

Global elements (notification bell, sync indicator, pending-count badge) belong
in the app shell, mounted once. Build them as **widgets** (route-agnostic), expose
them via the widget's public barrel, and mount only in the shell file — never
inside a specific page. Fine-grained gating lives inside the widget.

---

## Fill-in checklist (paste into the spec)

```markdown
## Navigation surfaces to update

- [ ] Route in `<router-file>`
      - Path: /<...>
      - Guard: [public / authenticated / admin / custom]
- [ ] Sidebar/nav in `<nav-file>`        (IF it's an entry point, not a detail)
      - Section: <...>
      - Permission flag: <...>
      - Icon: <...>
- [ ] Settings/menu in `<settings-file>` (IF it's a settings/admin screen)
      - Section: <...>
      - Gate: <...>
- [ ] Breadcrumb in `<breadcrumb-file>`  (IF slug != human label)
      - '<slug>': '<Human Label>'
- [ ] Route guard decision in `<router-file>` (always — state it explicitly)
- [ ] Top bar in `<shell-file>`          (IF a global header element)
      - Implemented as a widget; mounted only in the shell
```

---

## Manual verification

After implementing, walk through:

1. Sign in as an authorized user → the nav entry appears.
2. Sign in as an unauthorized user → the entry is hidden (if gated).
3. Navigate to the URL directly → the screen loads (or redirects per the guard).
4. The breadcrumb shows the human label, not the raw slug.
5. If it's a settings screen → it appears in the settings grid/menu.

---

## Sidebar vs not-sidebar

Goes in the sidebar **if** it is an entry point (list, dashboard, management) the
user reaches directly.

Does **not** go in the sidebar if it is:

- a detail view (`/<entity>/:id`),
- a wizard / sub-route,
- reachable only via a user/account menu.
