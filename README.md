# README

Run OpenCode within a local microVM.

## Requirements

1. Install `microsandbox`:

```bash
curl -fsSL https://install.microsandbox.dev | sh
```

2. Verify the host can run local microVMs:

```bash
msb doctor
```

3. Export the container image name to run. The provided microsandbox configuration assumes an Ubuntu base image:

```bash
docker build -t opencode-msb:latest .
```

4. Export required environment variables:

```bash
set -a
source .env
set +a
```

5. If the container image is on the local machine, it must be loaded inside microsandbox:

```bash
docker save opencode-msb | msb load
```

## Usage

Named sandbox you can stop and restart later:

```bash
msb run --conf microsandbox.yaml --mount-dir <LOCAL_PATH>:<REMOTE_PATH> --name opencode-msb
```

Enter again the sandbox:

```bash
msb exec opencode-msb
```

Stop and remove it when finished:

```bash
msb stop opencode-msb
msb rm opencode-msb
```

One-off OpenCode command:

```bash
msb run --conf microsandbox.yaml -- opencode run "Hello!"
```

## Further Reading

- [microsandbox CLI configuration](https://docs.microsandbox.dev/cli/configuration)
- [OpenCode v2 docs](https://opencode.ai/v2/docs)
