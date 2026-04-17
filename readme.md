# skill-copy

Skill de copywriting para OpenClaw, com escopo completo:

- Social media copy (posts, legenda, carrossel)
- Ad copy (Meta, Google, LinkedIn, TikTok)
- Sales copy (landing page, email, oferta)

Este projeto foi estruturado para distribuicao e instalacao em OpenClaw.
Nao instala nada no Cursor.

## Estrutura

```text
skill-copy/
├── install.sh
└── skills/
    └── copywriting/
        ├── SKILL.md
        ├── evals/
        │   └── evals.json
        └── references/
            ├── copy-frameworks.md
            └── natural-transitions.md
```

## Instalacao no OpenClaw

### Opcao 1: Uma linha com curl (rapida)

Instala direto do repositório no branch `main`:

```bash
curl -fsSL https://raw.githubusercontent.com/devfraga/skill-copy/main/install.sh -o install.sh
less install.sh
bash install.sh
```

### Opcao 2:

```bash
curl -fsSL https://raw.githubusercontent.com/devfraga/skill-copy/main/install.sh -o install.sh
bash install.sh
```

### Opcao 3: Script local (recomendado para desenvolvimento)

No terminal, dentro da pasta do projeto:

```bash
chmod +x install.sh
./install.sh
```

O script tenta:

1. Detectar `~/.openclaw/workspace-*`
2. Copiar a skill para `skills/marketing/copywriting.md`
3. Copiar evals para `skills/marketing/copywriting.evals.json`
4. Atualizar `_index.md` e `_changelog.md` se existirem

Se nao encontrar OpenClaw, ele mostra instrucoes manuais.

### Opcao 5: Instalacao manual

1. Copie `skills/copywriting/SKILL.md`
2. Cole em `<workspace-openclaw>/skills/marketing/copywriting.md`
3. (Opcional) Copie `skills/copywriting/evals/evals.json`
   para `<workspace-openclaw>/skills/marketing/copywriting.evals.json`
4. (Opcional) Atualize `_index.md` e `_changelog.md`

## Uso

No OpenClaw, acione:

```text
/copywriting
```

Exemplos de pedido:

- "Crie copy para um anuncio Meta com foco em leads"
- "Melhore essa headline da minha landing page"
- "Escreva um email de venda para oferta de consultoria"
- "Me de duas versoes A/B para esse criativo"

## Referencias usadas para estruturar este projeto

- [okjpg/skill-creator](https://github.com/okjpg/skill-creator)
- [coreyhaines31/marketingskills](https://github.com/coreyhaines31/marketingskills)
- [skills.sh/copywriting](https://skills.sh/coreyhaines31/marketingskills/copywriting)
