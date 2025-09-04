# Redis Demo Launchpad

Redis Demo Launchpad is a scalable GitOps platform for deploying **temporary cloud demo environments** across **Azure**, **AWS**, **GCP**, and **Redis Cloud**. Each demo is isolated, uses a unique identifier, and supports flexible deployment tools such as **Terraform**, **Bicep**, **Pulumi**, and **Redis Cloud API/CLI**. All deployments are managed via **GitHub Actions**, with no local tools required.

## ⚡ Quick Launch

> 🚀 **[Launch a Demo](https://tfindelkind-redis.github.io/redis-demo-launchpad/launcher.html)** - Use our web-based launcher to easily search, filter, and deploy demos.
>
> Note: After forking/cloning this repo, enable GitHub Pages in repository Settings > Pages (select "GitHub Actions" as source) to activate your launcher.

---

## �️ Development with Codespaces

This repository is configured for GitHub Codespaces with all necessary tools pre-installed:
- Azure CLI
- GitHub CLI
- VS Code Azure extensions

To create a Service Principal using Codespaces:

1. Click the "Code" button on the repository and select "Create codespace on main"
2. Once the codespace loads, open a terminal
3. Log in to Azure:
   ```bash
   az login --use-device-code
   ```
4. Run the service principal creation script:
   ```bash
   chmod +x ./scripts/create_sp.sh
   ./scripts/create_sp.sh
   ```

## �📚 Documentation & User Guides

- [Admin Guide](docs/admin.md)
- [Demo Creator Guide](docs/demo-creator.md)
- [Deployer Guide](docs/deployer.md)
- [Problem Reporter Guide](docs/reporter.md)
- [Problem Resolver Guide](docs/resolver.md)
- [Reference Guide](docs/reference.md)
- [FAQ & Troubleshooting](docs/faq.md)
- [Contributing Guide](CONTRIBUTING.md)

---

## 🧭 Project Goals

1. Deploy short-lived demo environments for presentations or testing.
2. Support multiple cloud providers: Azure, AWS, GCP, Redis Cloud.
3. Allow flexible use of deployment tools (Terraform, Bicep, Pulumi, Redis Cloud API/CLI).
4. Avoid any local dependencies or CLI tools.
5. Enable centralized orchestration via GitHub Actions.
6. Scale to support 100+ unique demos with different configurations.
7. Centralize demo metadata for easier management and dashboard generation.
8. Provide templates and automation for rapid demo creation.
9. Automate cleanup of expired or unused demo environments.
10. Use secure, short-lived credentials via GitHub Actions and OIDC.
11. Refactor workflows for reusability and reduced duplication.
12. Track demo status and lifecycle for visibility.
13. Enhance dashboard with live status, filtering, and action triggers.
14. Add automated tests for demo deployments.
15. Document onboarding, demo creation, and troubleshooting.
16. Enable users to clone the repo and customize settings (e.g., cloud subscriptions, secrets) for their own environments.

---

## 🚀 Quick Start

1. Clone this repository.
2. Review the [Deployer Guide](docs/deployer.md) to deploy an existing demo.
3. To add a new demo, see the [Demo Creator Guide](docs/demo-creator.md).
4. For admin setup, see the [Admin Guide](docs/admin.md).

---

## 🗂️ Repository Structure

```plaintext
.
├── demos/
│   ├── demo-001-azure-bicep/
│   │   ├── id.txt
│   │   ├── deploy.bicep
│   │   └── workflow.yml
│   ├── demo-002-aws-terraform/
│   │   ├── id.txt
│   │   ├── main.tf
│   │   └── workflow.yml
│   ├── demo-003-gcp-pulumi/
│   │   ├── id.txt
│   │   ├── index.ts
│   │   └── workflow.yml
│   ├── demo-004-rediscloud-api/
│   │   ├── id.txt
│   │   ├── deploy.sh           # Example: Redis Cloud API/CLI script
│   │   └── workflow.yml
│   └── ... (more demos)
│
├── templates/
│   ├── azure-bicep/
│   │   ├── deploy.bicep
│   │   └── workflow.yml
│   ├── aws-terraform/
│   │   ├── main.tf
│   │   └── workflow.yml
│   ├── gcp-pulumi/
│   │   ├── index.ts
│   │   └── workflow.yml
│   ├── rediscloud-api/
│   │   ├── deploy.sh
│   │   └── workflow.yml
│   └── ... (more templates)
│
├── .github/
│   ├── workflows/
│   │   ├── dispatch.yml         # Central dispatch workflow
│   │   ├── cleanup.yml          # Automated cleanup workflow
│   │   ├── reusable-steps.yml   # Common workflow logic
│   │   └── test.yml             # Automated tests for deployments
│   └── ISSUE_TEMPLATE.md        # Demo status tracking via issues
│
├── site/
│   ├── index.html               # Dashboard homepage
│   ├── style.css
│   ├── script.js
│   └── index.json               # Centralized demo metadata
│
├── docs/
│   ├── README.md                # Main documentation
│   ├── onboarding.md            # Onboarding guide
│   ├── demo-creation.md         # How to create new demos
│   ├── troubleshooting.md       # Troubleshooting guide
│   └── customization.md         # How to clone and customize repo
│
├── scripts/
│   ├── scaffold-demo.sh         # Script to scaffold new demos
│   ├── validate-config.sh       # Script to validate user settings
│   └── ... (other automation scripts)
│
└── .gitignore
```

---

## 🚀 How It Works

- **Centralized Source:** All demo templates and workflows are maintained in this repository.
- **User Customization:** Users can fork or clone this repo into their own GitHub account, update cloud settings, secrets, and configurations as needed.
- **No Local Tools Needed:** All provisioning and management is handled via GitHub Actions.
- **Secure Credentials:** Users store their own cloud credentials and secrets in their GitHub repository settings.
- **Scalable & Flexible:** Supports 100+ demos, multiple clouds, and deployment tools including Redis Cloud.
- **Automated Lifecycle:** Includes automated cleanup, status tracking, and dashboard for live visibility.

---

## 📚 Documentation

See the documentation links above for guides on onboarding, demo creation, troubleshooting, and customization for each user role.

---

## 📝 Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details.

---

## 🏷️ License

[Your License Here]