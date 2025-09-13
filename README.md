# Academic Docker

A comprehensive Docker image for academic research combining R, Stata, Quarto, and LaTeX in a development-ready environment.

## 🚀 Features

- **R Environment**: Latest R with rig package manager, renv for reproducible environments
- **Statistical Software**: Stata 19.5 MP (AMD64 builds only)
- **Document Generation**: Quarto for modern scientific publishing
- **LaTeX Support**: full Texlive 2025 distribution
- **Development Tools**: VS Code dev container ready with language servers and debugging
- **Multi-Architecture**: Native builds for both AMD64 and ARM64

## 📦 What's Included

### Core Software
- **R**: Version-specific installation via rig
- **Stata**: 19.5 MP (AMD64 only)
- **Quarto**: Latest version for reproducible documents
- **Texlive**: Complete LaTeX distribution

### R Packages
- **Essential**: `renv`, `rmarkdown`, `tinytex`, 
- **Development**: `languageserver`, `vscDebugger`, `httpgd`, `testthat`
- **Data Science**: Ready for package installation via `pak`

### Development Environment
- **Shell**: Zsh with Oh My Zsh, autosuggestions, and syntax highlighting
- **Editor Support**: R language server, Python radian REPL
- **Tools**: Git, htop, jq, nano, and essential utilities

## 🏗️ Architecture-Specific Base Images

- **AMD64**: Built on `dataeditors/stata19_5-mp:2025-05-21` (includes Stata)
- **ARM64**: Built on `ubuntu:22.04` (R and Quarto only)

## 📋 Usage

To use Stata, ensure you are on an AMD64 architecture. You should also supply a valid Stata license file in the container. The licence file is a text file that contains a single line formatted as follows `[serial number]![code (with spaces)]![authorization]![your name]!!1355!`. The license file should be named `stata.lic` and placed in the `/usr/local/stata/` directory. 

### Pull the Latest Image

```bash
# Latest release
docker pull ghcr.io/rferrali/academic-docker:latest

# Specific R version
docker pull ghcr.io/rferrali/academic-docker:4.5.1
docker pull ghcr.io/rferrali/academic-docker:4.5
docker pull ghcr.io/rferrali/academic-docker:4
```

### Run Interactive Session

```bash
# Basic usage
docker run -it --rm ghcr.io/rferrali/academic-docker:latest

# With volume mounting
docker run -it --rm \
  -v $(pwd):/workspaces/project \
  # stata license file mount (AMD64 only)
  -v /path/to/stata.lic:/usr/local/stata/stata.lic \
  ghcr.io/rferrali/academic-docker:latest

# With R package cache volume
docker run -it --rm \
  -v $(pwd):/workspaces/project \
  # stata license file mount (AMD64 only)
  -v /path/to/stata.lic:/usr/local/stata/stata.lic \
  # R package cache volume
  -v devcontainer-renv-cache:/renv/cache \
  ghcr.io/rferrali/academic-docker:latest
```

### VS Code Dev Container

Create `.devcontainer/devcontainer.json`:

```json
{
  "name": "Academic Research",
  "image": "ghcr.io/rferrali/academic-docker:latest",
  "customizations": {
    "vscode": {
      "extensions": [
        "REditorSupport.r",
        "quarto.quarto",
        "James-Yu.latex-workshop",
        "kylebarron.stata-enhanced"
      ],
      "settings": {
        "r.bracketedPaste": true,
        "r.rterm.linux": "/home/vscode/.local/bin/radian",
        "r.plot.useHttpgd": true,
        "latex-workshop.formatting.latex": "latexindent"
      }
    }
  },
  "postStartCommand": [
    "Rscript /startup_scripts/check_dev_dependencies.R",
    "Rscript /startup_scripts/check_test_dependencies.R"
  ],
  "mounts": [
    "source=devcontainer-renv-cache,target=/renv/cache,type=volume",
    "source=/path/to/stata.lic,target=/usr/local/stata/stata.lic,type=bind"
  ]
}
```

### Docker Compose

```yaml
version: '3.8'
services:
  research:
    image: ghcr.io/rferrali/academic-docker:latest
    volumes:
      - .:/workspaces/project
      - devcontainer-renv-cache:/renv/cache
    environment:
      - RENV_PATHS_CACHE=/renv/cache
    stdin_open: true
    tty: true

volumes:
  devcontainer-renv-cache:
```

## 🏷️ Available Tags

Images are tagged by R version and follow this pattern:

- `latest` - Latest stable release
- `{version}` - Specific R version (e.g., `4.5.1`)

### Current Versions
- **R**: As specified in tag
- **Stata**: 19.5 MP (AMD64 only)
- **Quarto**: Latest available
- **TinyTeX**: Latest available

## 🔧 Development

### Building Locally

```bash
# Build for current architecture
docker build -t academic-docker --build-arg R_VERSION=4.5.1 --build-arg TL_SCHEME=scheme-full .

# Build multi-architecture (requires Docker Buildx)
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  --build-arg R_VERSION=4.5.1 \
  --build-arg TL_SCHEME=scheme-full \
  -t academic-docker .
```

### Creating a New Release

```bash
# Use the provided script
./update-r-version.sh 4.5.2

# This will:
# 1. Create git tag v4.5.2
# 2. Push tag to GitHub
# 3. Trigger automated build
# 4. Publish as r4.5.2 and latest
```

### Project Structure

```
├── Dockerfile              # Multi-stage, multi-arch build
├── .github/workflows/
│   └── docker-publish.yml  # Automated CI/CD
├── startup_scripts/
│   └── *.R                 # Environment setup scripts
└── update-r-version.sh     # Release management script
```

## 🌟 Use Cases

### Academic Research
- Statistical analysis with R and Stata
- Reproducible research with renv
- Document generation with Quarto
- Collaborative development with containers

### Teaching
- Consistent environment across students
- Pre-configured with academic packages
- Easy deployment in cloud environments
- Support for both individual and classroom use

### Data Science
- Multi-language statistical computing
- Professional document generation
- Version-controlled environments
- Cloud-native deployment ready

## 🛠️ Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `RENV_PATHS_CACHE` | `/renv/cache` | R package cache directory |
| `RENV_CONFIG_PAK_ENABLED` | `TRUE` | Enable pak for package installation |
| `LANG` | `en_US.UTF-8` | System locale |

## 📁 Important Directories

| Path | Purpose |
|------|---------|
| `/workspaces` | Default working directory |
| `/renv/cache` | R package cache (volume mount recommended) |
| `/startup_scripts` | Environment setup and validation scripts |
| `/home/vscode` | User home directory |

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test locally with Docker build
5. Submit a pull request

### Guidelines
- Maintain multi-architecture compatibility
- Update documentation for new features
- Test on both AMD64 and ARM64 if possible
- Follow semantic versioning for R versions

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

## 🐛 Issues & Support

- **Bug Reports**: [GitHub Issues](https://github.com/rferrali/AcademicDocker/issues)
- **Feature Requests**: [GitHub Discussions](https://github.com/rferrali/AcademicDocker/discussions)
- **Documentation**: This README and inline comments

## 🔗 Related Projects

- [Rocker Project](https://rocker-project.org/) - R Docker images
- [Quarto](https://quarto.org/) - Scientific publishing system
- [Texlive](https://www.tug.org/texlive/) - LaTeX distribution
- [rig](https://github.com/r-lib/rig) - R installation manager

---

**Built with ❤️ for the academic community**
