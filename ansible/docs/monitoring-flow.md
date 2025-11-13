# Monitoring Data Flow

```mermaid
flowchart LR
    control[Control Node<br/>Ansible Controller] -->|SSH| servers[(Managed Server)]
    servers -->|Gather facts<br/>/metrics| metrics[CPU / RAM / Disk checks]
    servers -->|HTTP probe| website{Website status}
    metrics --> templates{{Ansible templates}}
    website --> templates
    templates --> data[(dashboard/data.json)]
    templates --> status[(dashboard/website_status.json)]
    servers --> logs[(logs/monitoring.log)]
    control --> ci[(CI: yamllint & ansible-lint)]
    ci --> control
```

**Legend**

- `metrics` — shell-based samplers using standard Linux tools.
- `templates` — JSON render via Jinja2.
- `logs` — chronological health feed for post-mortems.
- `ci` — automated linting (GitHub Actions).

