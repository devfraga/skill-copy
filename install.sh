#!/usr/bin/env bash
set -euo pipefail

SKILL_SLUG="copywriting"
SKILL_GROUP="marketing"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_SKILL="$SCRIPT_DIR/skills/$SKILL_SLUG/SKILL.md"
SOURCE_EVALS="$SCRIPT_DIR/skills/$SKILL_SLUG/evals/evals.json"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

ok() { echo -e "${GREEN}✓${NC} $1"; }
warn() { echo -e "${YELLOW}!${NC} $1"; }
err() { echo -e "${RED}✗${NC} $1"; }

manual_instructions() {
  echo ""
  warn "Instalacao automatica indisponivel."
  echo "Instalacao manual para OpenClaw:"
  echo "1) Copie: $SOURCE_SKILL"
  echo "2) Cole em: <workspace-openclaw>/skills/$SKILL_GROUP/$SKILL_SLUG.md"
  echo "3) (Opcional) Copie evals:"
  echo "   $SOURCE_EVALS"
  echo "   para: <workspace-openclaw>/skills/$SKILL_GROUP/${SKILL_SLUG}.evals.json"
  echo "4) (Opcional) Atualize _index.md e _changelog.md do workspace."
  echo ""
}

find_openclaw_workspace() {
  local base=""
  if [ -d "/root/.openclaw" ]; then
    base="/root/.openclaw"
  elif [ -d "$HOME/.openclaw" ]; then
    base="$HOME/.openclaw"
  else
    return 1
  fi

  local workspaces=()
  while IFS= read -r dir; do
    workspaces+=("$dir")
  done < <(find "$base" -maxdepth 1 -type d -name "workspace-*" 2>/dev/null | sort)

  if [ "${#workspaces[@]}" -eq 0 ]; then
    return 1
  fi

  if [ "${#workspaces[@]}" -eq 1 ]; then
    echo "${workspaces[0]}"
    return 0
  fi

  echo "Workspaces OpenClaw encontrados:"
  for i in "${!workspaces[@]}"; do
    echo "[$i] ${workspaces[$i]}"
  done
  read -r -p "Escolha o indice do workspace [0]: " idx
  idx="${idx:-0}"
  echo "${workspaces[$idx]}"
}

update_index_if_exists() {
  local index_file="$1"
  local today="$2"
  if [ -f "$index_file" ]; then
    echo "| $SKILL_SLUG | $SKILL_GROUP | $today | DRAFT |" >> "$index_file"
    ok "_index.md atualizado"
  else
    warn "_index.md nao encontrado; pulando atualizacao."
  fi
}

update_changelog_if_exists() {
  local changelog_file="$1"
  local today="$2"
  if [ -f "$changelog_file" ]; then
    {
      echo ""
      echo "## $today - $SKILL_SLUG instalado via install.sh"
      echo "- Skill instalada em skills/$SKILL_GROUP/$SKILL_SLUG.md"
    } >> "$changelog_file"
    ok "_changelog.md atualizado"
  else
    warn "_changelog.md nao encontrado; pulando atualizacao."
  fi
}

install_openclaw() {
  if [ ! -f "$SOURCE_SKILL" ]; then
    err "Arquivo de origem nao encontrado: $SOURCE_SKILL"
    exit 1
  fi

  local workspace=""
  workspace="$(find_openclaw_workspace || true)"
  if [ -z "$workspace" ]; then
    manual_instructions
    exit 0
  fi

  local today=""
  today="$(date +%Y-%m-%d)"
  local target_dir="$workspace/skills/$SKILL_GROUP"
  local target_skill="$target_dir/$SKILL_SLUG.md"
  local target_evals="$target_dir/${SKILL_SLUG}.evals.json"

  mkdir -p "$target_dir"
  cp "$SOURCE_SKILL" "$target_skill"
  ok "Skill instalada em: $target_skill"

  if [ -f "$SOURCE_EVALS" ]; then
    cp "$SOURCE_EVALS" "$target_evals"
    ok "Evals copiados para: $target_evals"
  else
    warn "Evals nao encontrados em $SOURCE_EVALS"
  fi

  update_index_if_exists "$workspace/_index.md" "$today"
  update_changelog_if_exists "$workspace/_changelog.md" "$today"

  echo ""
  ok "Instalacao OpenClaw concluida."
  echo "Para usar, invoque sua skill com: /$SKILL_SLUG"
}

echo "----------------------------------------"
echo "Instalador da skill $SKILL_SLUG (OpenClaw)"
echo "----------------------------------------"

install_openclaw
